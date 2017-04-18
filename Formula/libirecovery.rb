class Libirecovery < Formula
  desc "library for communication to iBoot/iBSS on iOS devices via USB."
  homepage "https://github.com/libimobiledevice/libirecovery"
  url "https://github.com/libimobiledevice/libirecovery/archive/master.tar.gz"
  version "0.2.0"
  sha256 "05c6fec3a1aff14111c4ae8252c802e2d583114474a9ae1b30e89fdb0f4edee4"

  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build

  def install
    system "./autogen.sh", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "ls", "#{lib}/libirecovery.dylib"
  end
end
