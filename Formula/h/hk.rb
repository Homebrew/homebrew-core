class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.8.0",
      revision: "672fd70a7e0cd1611b914c905cb4f47d9b7f2b6f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d8613e225989bcb9349056a10e54d3fad9c7928320f2de1b75865107dbb50d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71a8bf289ebb4d9d2080253b2e68f0701426d7ce54635309929b2578c6ea014b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8cf4717d96edfe1b38acff9bb4f899b482ee7410c3751da26ecb001b0457101"
    sha256 cellar: :any,                 arm64_linux:       "a00618240d0f1aae6772d2fc5e2fed7316dcfc8fc5f195bbd322bf520201468e"
    sha256 cellar: :any,                 x86_64_linux:      "f1fe8afb8c665340dd5a4197b3840b5d32f358d02cf58ab97b6134a767e4f2b5"
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
