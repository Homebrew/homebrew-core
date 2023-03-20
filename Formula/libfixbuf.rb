class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.4.2.tar.gz"
  sha256 "4286d94224a2d9e21937b50a87ee1e204768f30fd193f48f381a63743944bf08"
  license "LGPL-3.0-only"

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9187d2b567986e32c060ab687d8f6ef1a2a5290ed8a5fef15b32c22d793bb21e"
    sha256 arm64_monterey: "b02a896fe100021e8fbfaa0731578452097232e1102763725bb6490291ff1635"
    sha256 arm64_big_sur:  "73149cc50b6cc5c0269a140fddb904b8412201b26325c06fdfc8a4533d638671"
    sha256 ventura:        "d2eed42c0dcc8950027df4809287a97e77a1376a9b33497adb5d3db6fc07f242"
    sha256 monterey:       "f9b405fb82cc27bc3656a21e8c56c0c9b0d5772e258ccd27c86f5bc1a9a84c1a"
    sha256 big_sur:        "e96af7ab90b912487891b04590a6a1e55ed4d4bc42631b935e2e50161d8d668a"
    sha256 x86_64_linux:   "3468fb8842f3b2d131eee19c79f36a5740c15eed95a604210671aafe423aa90c"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
