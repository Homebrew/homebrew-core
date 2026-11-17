class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.13.0",
      revision: "fabfffc629aec46f8de96db2d9ab27cfe77b9615"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cc51ca2482a5ca71391695cce4cabad48e3a40976e4dbf8f775f4d6ef5e9b53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6c251d2593e009e7afe40acadeef1d4bc93c88253cfa06a5a54642c287d89be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c84b6817d372bd62dc3904e8a2b37c9c1e52abd5e3fbbee65a013570b9481fe"
    sha256 cellar: :any,                 arm64_linux:       "82b800fba36c2b956d848692435af02a66a6fafe661b31e0e360b769dad19bd5"
    sha256 cellar: :any,                 x86_64_linux:      "bb665e7808f8f8b5aa0db559e3500222647f7b7717cfef3ddd92009f02a1eb22"
  end

  depends_on "pkl" => :build
  depends_on "rust" => [:build, :test]

  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    # `mise run pkl:gen` - https://github.com/jdx/hk/blob/main/mise-tasks/pkl/gen
    system "python3", "scripts/gen_builtins.py"
    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "homebrew", "--name=brew"

    cd "homebrew" do
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"

      system "git", "add", "--all"
      system "git", "commit", "-m", "Initial commit"

      output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
      assert_match "cargo-clippy", output
    end
  end
end
