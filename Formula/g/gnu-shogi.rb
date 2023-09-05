class GnuShogi < Formula
  desc "Japanese Chess"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftp.gnu.org/gnu/gnushogi/gnushogi-1.4.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnushogi/gnushogi-1.4.2.tar.gz"
  sha256 "1ecc48a866303c63652552b325d685e7ef5e9893244080291a61d96505d52b29"
  license "GPL-3.0"

  bottle do
    sha256 arm64_ventura:  "f9146b1d94cf4b8376d8c71330f3aea6cad33ebf9af54f9d2e423750ac0b688f"
    sha256 arm64_monterey: "00b93fd4eaba3beab5e1824a8a6bf62b446f8767ca26c80c3c2ed5f12ac6e3d9"
    sha256 arm64_big_sur:  "106fee874d8adf30ee887dcf7aa6149cd469c3e629861d105a278a9a66318aea"
    sha256 ventura:        "ef6c5d508b5a76bc305290ee3e644c2823691b168752feab79f3a4ce79379fb8"
    sha256 monterey:       "c07b78082a29a7db9d4d19fa81f61e7dd89c0f1f184e946e2012fa2fc4bed9d0"
    sha256 big_sur:        "70258434181a6f40b0c3cddb7e2a5f0119bf953bff5dbd3e795533f558a104ea"
    sha256 catalina:       "6c559fdfcd24543c1f83f681fe3337048783d17649804b642fb0063dee88d7c8"
    sha256 mojave:         "c52d5743a6b9b6aeff9ba4b87104fa7adb58e7752683420e2c038f0216a2447d"
    sha256 high_sierra:    "20895a9d3fe87357df4dad1aaae16fee4d7a0c70e95119756c8ab2928817c161"
    sha256 sierra:         "677531c9eb7bdd01f22862c24d5ab144f7b78bd672223854fc169d103a9924e2"
    sha256 el_capitan:     "49ff431036e172362b24dc7eca426a638ec2953ea014c67e4cae239e9175bf27"
    sha256 x86_64_linux:   "7700579666c89c383d66c691c0deb1531fe3af8b886b1b74ed875803862c5223"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MANDIR=#{man6}", "INFODIR=#{info}"
  end

  test do
    (testpath/"test").write <<~EOS
      7g7f
      exit
    EOS
    system "#{bin}/gnushogi < test"
  end
end
