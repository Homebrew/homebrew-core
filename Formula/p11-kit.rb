class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.9/p11-kit-0.23.9.tar.gz"
  sha256 "e1c1649c335107a8d33cf3762eb7f57b2d0681f0c7d8353627293a58d6b4db63"

  bottle do
    sha256 "20df13634ab4690134d9fa3bfd662dff9cbdc5478a0906a3cc10e7c2ab5439ac" => :high_sierra
    sha256 "7ec97bd7114e80433e5a1d273606d7478ae8e7e158bb984f49c513df56eae446" => :sierra
    sha256 "da47a03cf395714dd86181a64d6188d048c81f330815bf171d8cff95de6f7a41" => :el_capitan
    sha256 "bcbffb5dcddd7cfec4f4fb26ab1dd3c4baa259f450e25b13975f88c94699ab7b" => :yosemite
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
