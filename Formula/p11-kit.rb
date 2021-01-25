class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.22/p11-kit-0.23.22.tar.xz"
  sha256 "8a8f40153dd5a3f8e7c03e641f8db400133fb2a6a9ab2aee1b6d0cb0495ec6b6"
  license "BSD-3-Clause"

  bottle do
    sha256 "9474fe6483bbc394d9069f79528ecfe9ba1af00db4aca23c26857b6b66736d73" => :big_sur
    sha256 "0cd22f169cd684116fdeb4e52cf551950d1a0c2cced55ee903bf694a0d9d6866" => :arm64_big_sur
    sha256 "d02045826811eeb8475b535be7331c0770fdc930d1ac1be86796af81141e8592" => :catalina
    sha256 "4d35cd8fd37b06687b5025354f3a579ab2e36e8ab8bd9bab75102eee14bd86f4" => :mojave
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
