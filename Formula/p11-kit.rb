class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz"
  sha256 "1cb9fa6d237539f25f62f4c3d4ec71a1c8e0772957ec45ec5af92134129e0d70"

  bottle do
    sha256 "42760c3b204ec89a91c3d6612faa7dd12e4a15673bf324e41ae4952ae7cab790" => :mojave
    sha256 "d1c17d13b8b3a2257c3273d1be310128c370a2a3f9542b9ffe7eb1e92a094846" => :high_sierra
    sha256 "8e1a60e5e5f876636c8e6b2124bf0107d5f7c570a00082cc55a372a71e2cb819" => :sierra
    sha256 "af9c149cd855e559ec2d7547746da8370f8b5037048e419d04ce744c6316fc48" => :el_capitan
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
