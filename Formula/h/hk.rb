class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.11.0",
      revision: "a0c22a90ac075f52c774cf8be8bf4e45d2b6a42a"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4881881c50e97f3aa9dad227d68475759be086145246b12e0e559a961369fe06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bf78d75a2706e6b3539842efd1ac8d891584d12ad0978856dd3a0709a2e12d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "779c14b7f18592c787ef2d902df7e66367895d1e9a2b74409782b16a027e6e7a"
    sha256 cellar: :any,                 arm64_linux:       "73633818c6ef915207d82a2fc65b9d2f030b3ffad71eeecd1cf23cc9c6fa9123"
    sha256 cellar: :any,                 x86_64_linux:      "5a5766695674867c26cf9e0f5c84699843816f3d759f5c6e043aa79e5a392b31"
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
