class Idevicerestore < Formula
  desc "Command-line application to restore firmware files to iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/idevicerestore/releases/download/1.0.0/idevicerestore-1.0.0.tar.bz2"
  sha256 "32712e86315397fd2e8999e77a2d2f790c67f6b4aa50d4d1c64cb2c4609836f7"
  license "LGPL-3.0-only"

  head do
    url "https://git.libimobiledevice.org/idevicerestore.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libirecovery"
  depends_on "libplist"
  depends_on "libzip"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/idevicerestore", "--help"
  end
end
