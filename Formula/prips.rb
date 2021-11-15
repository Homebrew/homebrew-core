class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.1.1.tar.xz"
  sha256 "16efeac69b8bd9d13c80ec365ea66bc3bb8326dc23975acdac03184ee8da63a8"

  livecheck do
    url :homepage
    regex(/current version .*?prips.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d7f109b9cbfe943a347d422d95d26842d1dfc9db5c5d5b55a2376d7cdde285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "500cfb4e4680b767d3a765e542e59660ed07d05724902e43d243be184194e916"
    sha256 cellar: :any_skip_relocation, monterey:       "e78b78b196d422f81ad691b34030ee02d22e0b16e463bf009f09892ac98b0aa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "19470cbc2e9339887d983fe9e008a70c861cbe81c22c493bb83b9550d4204994"
    sha256 cellar: :any_skip_relocation, catalina:       "06f354f3564aa9aa391d56b952fb97056c911f32232f6afeefcb23bce5a8bc0c"
    sha256 cellar: :any_skip_relocation, mojave:         "771e030cbbf61a7914af375462d24bc2fccb6e60e8959110906e23544aacbb17"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ecf0f743bfaffc303c8f520f5f29f10917b63708866fc50553c10f6952c5e06e"
    sha256 cellar: :any_skip_relocation, sierra:         "65a400f8d42e7c38cbc26898dadf3110b0aad7e347ba40585f398d4bcc696d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512db8534902dfbd3c45b271dc0b22fa1399819706dc08871a4d5cb32220c854"
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
