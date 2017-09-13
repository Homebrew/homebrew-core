class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"

  stable do
    url "https://github.com/p11-glue/p11-kit/releases/download/0.23.8/p11-kit-0.23.8.tar.gz"
    sha256 "4ba134e5fe4b62bcaf7a2d66841767d9d23e875b977bba6939367a9f400b133f"

    # Remove for > 0.23.8
    # Fix "error: use of undeclared identifier 'SIZE_MAX'"
    # Upstream commit from 16 Aug 2017 "build: Include <stdint.h> for SIZE_MAX"
    patch do
      url "https://github.com/p11-glue/p11-kit/commit/61acf20.patch?full_index=1"
      sha256 "2d5e1c4bf8bf859aaf14ff14553cf1aad86090aa71e4f459439003328baa032e"
    end
  end

  bottle do
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
