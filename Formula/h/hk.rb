class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.44.2",
      revision: "3cb88fb883b29281fff68c4edfc57a5fb97758fd"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fa8267d902258a8f84fffc872dcb3721fb219389e48df76792efe06dd0536bb"
    sha256 cellar: :any,                 arm64_sequoia: "c429855b00ab055a2de86b4c5125fff2e34e8dac3396fa5c29b070ff43be2595"
    sha256 cellar: :any,                 arm64_sonoma:  "87ae06a92ff65a042895854825e9b245b67cc897bdabf20abe2fa72f24577a71"
    sha256 cellar: :any,                 sonoma:        "ca153f49b8839f15f3ee169006b86cc481048dab49c3aefc6fa691cf0b5371ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6fd7d57fb6e8cdadc5073cece169299025e14f566b0951618f07f12ad8b6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a51f939ec5e2bf321a59f626a3d11dc89338943653e145de840af4aecb7828"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
