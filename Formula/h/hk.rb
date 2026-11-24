class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v2.14.0",
      revision: "7beec88a9bf6a2214910709f5dde9c6447ebc71f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "ce817392c8ce911e5c6ad55f8ed52534fbe9a818795dca5d04c36056bed97d3f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "834da031c370c349ad6ca5e58941772f2f93c951a7db0d7ea8a32b1a848f50f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "517a64e1c0e1f901ea68900f0ffa3f4ec0719723aa5cc5e3a260204375f5daa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2104924e883adb6908507dade26819c6683e27e9763a53d174ed78a1a8fe925"
    sha256 cellar: :any,                 arm64_linux:       "025207fcca565333a9f26b7ed17800bf35182fbd320f7640477ee118353ad601"
    sha256 cellar: :any,                 x86_64_linux:      "33e3ec1cf260f0783a6c6c127973ff41041325972705c1fe9118b0b1a0a20313"
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
