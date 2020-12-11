class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.22/p11-kit-0.23.22.tar.xz"
  sha256 "8a8f40153dd5a3f8e7c03e641f8db400133fb2a6a9ab2aee1b6d0cb0495ec6b6"
  license "BSD-3-Clause"

  bottle do
    sha256 "88b116742f3623b5b7267d238dfeea868ba605f77cf2bbc73baf89c62de374c1" => :big_sur
    sha256 "5db3eb53ab94052a70d6b0a4da2d42f3b5fa1071d3b33679813126d67b24882b" => :arm64_big_sur
    sha256 "ed88cc1b217c82bcef27d3ca176fb8e641845b7d9f7639005c98c400ee3ee862" => :catalina
    sha256 "3e20aaab1fff56e04161bb1b8cd3cc1dda48d0c8245b98ee6e1b1fa88d7bf864" => :mojave
    sha256 "623167101752aafb916685b0b776029cdce91eca3ae0a8340cbfe2eadaa5fba3" => :high_sierra
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
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
