class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0fbc71300694873951ea2fd12919f54778325b9f1c8aa222df324e4fabe1044f"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f8f72b9778698515f9d35adbea146ed1dadc051d639053aa2023277d6f43e5f"
    sha256 cellar: :any,                 arm64_sonoma:  "0d791ca24a5fb16017bc13e7db658f35f8b16b27b0b5d1d06e51564349598cd0"
    sha256 cellar: :any,                 arm64_ventura: "0124a7352045100fa24218c97aece79c208f36124edd6adf28c76160dd8d808b"
    sha256 cellar: :any,                 sonoma:        "2929b2ed87b34bc00f1798a43b1b47c1c064eb82aa1f46685415a18f5d985f29"
    sha256 cellar: :any,                 ventura:       "d7bf4733533e5c882f5b02cdcbaad483356b8f0a177e9a92c22f530634aefb48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a281a2d962feddee08dc30a0ded252cbcab90dd365b6646472c4617b6098537d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc566741555a489e2fff2d2f58a015bd59973874a6b9621086b74e755e9f934"
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
