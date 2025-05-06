class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "92fca894ee9784feb29814ac737ac8a01058bdec41348c7deb04f00a626b1774"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6f3dde7fb46907523e40c8fa741112876849c0f25bdae627ccb61e5ad648db2"
    sha256 cellar: :any,                 arm64_sonoma:  "6fbc0a3a981e7f27a568bd54f37e3c2870570bc8fcc0deef05e9675ab21e31f3"
    sha256 cellar: :any,                 arm64_ventura: "f29d2f9569f14b3454a23fd159edd005962ee589d7dc7b250eb7dc972ad07590"
    sha256 cellar: :any,                 sonoma:        "9bae4daee0b31f43025e94d20317352ea748862e91a181e6d667e5696d7feebe"
    sha256 cellar: :any,                 ventura:       "a54cb3e7a0c40dd9461d3c488e48be479caffbcb2220dd89eaaf4a9f9966057b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a93d25d54fa98aec9d61b6a6142f1c6f3249a4421547618214161df35b738a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8c89b184499f3c8faa41dd985c77a37bee6c5b0a5ca8549dcc0e9ee6312eb9"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

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
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
