class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "b848e6097444b56c41aba1e489dfb94e2b2695c09cf2b583b9b0bea2e771e292"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0747e8b6185f41648e55f70fbe6c00943d981293ff0485d21eac21b78ac70865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96512e0d40d7ecc8d4b197fa25a8a92d6af2e50f6e4013d14449554618af7847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "045ef64253da298d44c59b5dd4a7551cb564160d14815df324052fec3ba1c521"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb26686994fd4aa0d4d8f5bdce55e96462e5d2c64c6d38b7dfc88d43e360036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "977da3dc46c600e43c8e5eaeeb2dacee925ed090b36a2d78c2ee29f978b6bae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8030795c46d22bcf5c79bdd233be871a581e1f23fc7644cdd55fe43416f898bf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"
    expected = <<~EOS
      Now generate and add a new recipient key for yourself:
          prs recipients generate

    EOS

    assert_equal expected, shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_equal "prs #{version}\n", shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
