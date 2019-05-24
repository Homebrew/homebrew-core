class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.16.1/p11-kit-0.23.16.1.tar.gz"
  sha256 "4b34e92ae36fa493e0d94366c767f06d5f9951e3d8581d10fd935d738db1574d"

  bottle do
    sha256 "49ffd7c971e56e2ef825e7af091064c301ca616bbe9092cd5c46a20f917783cc" => :mojave
    sha256 "350b021e34d17250e61890c699f10a125d243b7194924cc7df3224a2984bf281" => :high_sierra
    sha256 "0abc56197c864a9554e8211f824461deb449f9d4f95fdc6f5890ff355d732f6a" => :sierra
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
