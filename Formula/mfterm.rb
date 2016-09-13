class Mfterm < Formula
  desc "Terminal for working with Mifare Classic 1-4k Tags"
  homepage "https://github.com/4ZM/mfterm"
  url "https://github.com/4ZM/mfterm/archive/v1.0.6.tar.gz"
  version "1.0.6"
  sha256 "19adfe858cfa5c672aa543b1c6b439384597cb21f880ed74c9b26e5164006221"

  head do
    url "https://github.com/4ZM/mfterm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libnfc"
  depends_on "libusb"
  depends_on "openssl"

  def install
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"

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
