class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.11.1",
      revision: "d2d7bf6833cb44607dc243dd43c0e606a43780ca"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d2e9b6f7c179dbe32dc6ed3b74070aa3771f7e7ddc68ba108fbe685e50c2501"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fc60b658fe8536139ba7fc249456717887f108f04843ade659e5e3d6b746f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bfbb141c5e92255a2abb5cbbb2e4637712f0d228def334cf40c99c4ef7d9a0f"
    sha256 cellar: :any,                 arm64_linux:       "b6c2b4f419daa0bf41dacaf5ad75ca2c02b0c82ffd81cb4c6eb89cae6bca14ca"
    sha256 cellar: :any,                 x86_64_linux:      "24d34f20f61bcbc43d77d83c0abe672abf5ab412c187bdcae99f30b1ec8f1766"
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
