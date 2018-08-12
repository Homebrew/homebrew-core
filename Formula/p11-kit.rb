class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.13/p11-kit-0.23.13.tar.gz"
  sha256 "aa65403e3ac7c3aba17ca60f28db17b9c76d988b66b91789b8e8c145ae9922f1"

  bottle do
    sha256 "86042bac280ab02f1adbf13bfd1b7e759907080b1a5e18ccce4641289cb86053" => :high_sierra
    sha256 "545313227dff8580e9f6f94edcf430faf1cb9b4079474941480cb9b0c6b9966b" => :sierra
    sha256 "a9bc2a4b94cfe1bd8ec4409c60b698641c5a0c61cd3b98b33f734d164aa5c7b5" => :el_capitan
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
