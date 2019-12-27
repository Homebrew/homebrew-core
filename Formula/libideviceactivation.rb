class Libideviceactivation < Formula
  desc "Library to handle the activation process of iOS devices"
  homepage "https://www.libimobiledevice.org/"
  head "https://github.com/libimobiledevice/libideviceactivation.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  uses_from_macos "libxml2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-debug-code"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceactivation", "--help"
  end
end
