class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.21/p11-kit-0.23.21.tar.xz"
  sha256 "f1baa493f05ca0d867f06bcb54cbb5cdb28c756db07207b6e18de18a87b10627"
  license "BSD-3-Clause"

  bottle do
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
