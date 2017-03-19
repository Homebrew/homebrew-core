class Ifuse < Formula
  desc "FUSE module for iPhone and iPod Touch devices"
  homepage "http://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.3.tar.gz"
  sha256 "9b63afa6f2182da9e8c04b9e5a25c509f16f96f5439a271413956ecb67143089"
  head "http://cgit.sukimashita.com/ifuse.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
