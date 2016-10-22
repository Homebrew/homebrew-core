class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz"
  sha256 "ba726ea8303c97467a33fca50ee79b7b35212964be808ecf9b145e9042fdfaf0"
  revision 1

  bottle do
    sha256 "f8a576f0e0c58aeb43d0973c689d2de5d959febb86082d5f9505661402217946" => :sierra
    sha256 "056f262ed1ed5fa665885f577e5b2463429c255ff2a987c4f2af67f4f23e0a54" => :el_capitan
    sha256 "f82755ab85440b64ec4db85ecaee5c0185ba751a08d693fffd98f8f80c92afb5" => :yosemite
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
