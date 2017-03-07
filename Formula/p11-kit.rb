class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.5/p11-kit-0.23.5.tar.gz"
  sha256 "0d8fed192563c324bb5ace3c068f06558a5569a6e8eb47eee1cd79ada3b1124f"

  bottle do
    sha256 "5aa16ddaa7bb0c6fcf66122685337e9d98e421c9389fdff2250e6fd7cf4ef352" => :sierra
    sha256 "ea3948d2d030a226143afb6f0cf63ea7c7ed936078b7984c492e53e4dc05c8ff" => :el_capitan
    sha256 "122fa200388458776d870d483680f21d8bc755f62db1a87cab30338ab0ab445d" => :yosemite
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libffi"
  depends_on "pkg-config" => :build

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
