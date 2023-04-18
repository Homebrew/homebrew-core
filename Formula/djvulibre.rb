class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.28.tar.gz"
  sha256 "fcd009ea7654fde5a83600eb80757bd3a76998e47d13c66b54c8db849f8f2edc"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "256feac4187ce2c62a4a2a5b64cc6fbb6160c970b652b690fc1ed775efcf5adf"
    sha256 arm64_monterey: "c6c7e2fecb0958688027ef38a23b6e0a4e2df6de8a28a03a472ffa1fbc14de01"
    sha256 arm64_big_sur:  "c5d40805bec199c8c359f392b54ad3e1128f7debd0e6af393632e70721aa2a34"
    sha256 ventura:        "35be3b8037445f26f84b9168020058837a09d41964332aa7100d5a6d82542a29"
    sha256 monterey:       "113d7cb22d9b8b7ee7dbe524769068e12fcb6c5849211975b28b88a09644a366"
    sha256 big_sur:        "9afc5c5f891494305f70857cd767f1beae1e70e1d7e82498496b05a2944b5535"
    sha256 catalina:       "1ca7cb3fce3c2864bcc3411ba304fa953b39690082cb1d0cbd220a46f9ececee"
    sha256 x86_64_linux:   "da3cce41bd557ff4bfc7e5d75a6af20bd3e8a9f009fdfe83d63c21157d88213e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
