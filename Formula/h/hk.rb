class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "541b816e6fea13bd928ff16c309f61777ea4b9178b751b35deb3ce362daaeaa2"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25db281f77fb80d74199e8ca84880aecad1f6ac770bafce6981f0720794cbd6b"
    sha256 cellar: :any,                 arm64_sonoma:  "958a64aac3b146db121b1c2ff75caf623520bf489f5e62d831bb66eeec977c42"
    sha256 cellar: :any,                 arm64_ventura: "6d2645b7184c5a2f6671d001bc7247b11f91af71f342ef4a1bbd69467d24ac95"
    sha256 cellar: :any,                 sonoma:        "104aff665bcec584f692d17a196b1c6e8913099a1ad3d7c9c77f7b0d3a535742"
    sha256 cellar: :any,                 ventura:       "21ffab423d7547e01c98bec95acccd247a0b93af9da99f33d8b7d531fe3fdd79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d444fe06b6bad0f874d1c0455be1f3109427ddc78fea205894f5962c9a8274b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c043bfde79876daf18b8d335411c4e1468270003a1ba85dbce34474aed1b1c"
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
