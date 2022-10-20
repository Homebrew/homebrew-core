class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "25d1c5b0b52dcfb4dbef2f10bbd6a92ece2c4e1e8591a88634794de32cbd21a9"
    sha256 arm64_big_sur:  "3f242d37322198df162a1a8856a2c67aeaf36911dbdd82f47c232b27e6470e88"
    sha256 monterey:       "cbe7f1d2fe876a9efdb2baba1614564c5d8c75a63712af816b9932fefc75b5d6"
    sha256 big_sur:        "aad52aa6cbceca54d2904cfc839c21a8b5df724d1fc590b7fbefd73b2a17bb9f"
    sha256 catalina:       "5b87364ccf20291e52457a04b715336bd9c8020b116e016aaabe4569bf56730f"
    sha256 x86_64_linux:   "aa021251b0023cb0735e2f5a555293a92821e6454a98a0c66a0f8688b8f90ebb"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure",
           *std_configure_args,
           "--enable-multibyte=utf-8",
           "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end
