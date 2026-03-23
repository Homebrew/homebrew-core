class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  # pull from git tag to get submodules
  url "https://github.com/jdx/hk.git",
      tag:      "v1.39.0",
      revision: "53d02f2bf72a7187290ab07c74f5473c9fcfb72b"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78e3714c105d46dc189c8648e55454a17c7da7369960676c6306effe7a7e274c"
    sha256 cellar: :any,                 arm64_sequoia: "04a4075b34cebb7d443569a2b590ccc1dd120440c3e24a1785496aca28e31c80"
    sha256 cellar: :any,                 arm64_sonoma:  "e19ce82c56026f4806ab08cd0789a14627d8e0a905658f7c93d8fe949b64f732"
    sha256 cellar: :any,                 sonoma:        "b79a6cf8a6e0ddc24a4305f3a068983e959804bdf2eaa8aa88376c6f37e793ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e349d33d7112cfb511e3c155151325f9e818289da7b1eacb42032f7dd38d5426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db03aa4784bd1e4a84280af954a0908a797367cead7b3a7b7f4b036871887776"
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
    ENV["OPENSSL_NO_VENDOR"] = "1"

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

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
