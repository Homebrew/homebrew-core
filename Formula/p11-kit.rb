class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz"
  sha256 "ba726ea8303c97467a33fca50ee79b7b35212964be808ecf9b145e9042fdfaf0"
  revision 1

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

  # Remove for > 0.23.2
  # Upstream commit from 3 Oct 2016 "Fix link of p11-kit-proxy.dylib on Mac OS X"
  # https://bugs.freedesktop.org/show_bug.cgi?id=98022
  # https://cgit.freedesktop.org/p11-glue/p11-kit/commit/?id=6923e8fb56692b20d24398d4746d2399490acdc1
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5271336/p11-kit/p11-kit-proxy-so-link.patch"
    sha256 "a05a10c22a3053c5370678997aed0c200b866f4aea8c69c82665fc47d61466f9"
  end

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
