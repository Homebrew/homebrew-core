class Mfterm < Formula
  desc "Terminal for working with Mifare Classic 1-4k Tags"
  homepage "https://github.com/4ZM/mfterm"
  url "https://github.com/4ZM/mfterm/releases/download/v1.0.7/mfterm-1.0.7.tar.gz"
  sha256 "b6bb74a7ec1f12314dee42973eb5f458055b66b1b41316ae0c5380292b86b248"
  revision 1

  bottle do
    cellar :any
    sha256 "c9d9a6731bfde45dc690e9e2c3169ca93a110b2ca23a07f51c08d8f8194bfda9" => :mojave
    sha256 "009cdef40e9c20337824dae0e0dba9391fe003d47ad29e249959f5ef00294888" => :high_sierra
    sha256 "be663a931f9c81a3671c5dcb492b81a9d2f2bde40ef37bc1034f2ab6c0683cce" => :sierra
    sha256 "8d6a975a204105fea549d800093ee986c3f585d275ad75720746482e61d80053" => :el_capitan
    sha256 "da282f04765376dd1151dd4ae19394fe7504f5143bb5241cd538205c57d2ab3e" => :yosemite
  end

  head do
    url "https://github.com/4ZM/mfterm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libnfc"
  depends_on "libusb"
  depends_on "openssl@1.1"

  def install
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"

    if build.head?
      chmod 0755, "./autogen.sh"
      system "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/mfterm", "--version"
  end
end
