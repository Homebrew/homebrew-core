class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.3/p11-kit-0.23.3.tar.gz"
  sha256 "d487f04dba3f9e8256f53034c59c944ca45fd7b8434c095da6a74079644dcd82"

  bottle do
    sha256 "019c020bf72aee03d4ca861443045693ec97d189c08b3ae4f876f2491f1f9739" => :sierra
    sha256 "92286d6cfd85219abeca164062639b731dbfde4c96670f1a5e14571d04b2ca31" => :el_capitan
    sha256 "d7129f3799210816aa68fe35bd8a89766d164dfdfc608cc895595bbee4a76b84" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    system "autoreconf", "-fiv"
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
