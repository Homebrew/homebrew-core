class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.10/p11-kit-0.23.10.tar.gz"
  sha256 "f9212a3f225ef543e13fae9945527d66c0cbb67246320035dd94fab2bce5ae43"

  bottle do
    sha256 "d1a28a27c565eb0b14687b64f4bb3a643e1289bd3e59e8f82b2e73bac021eea2" => :high_sierra
    sha256 "d32f3d5d34f52c274a749d62bcaf3ce1814cc133fad89d09cec74f2227c43702" => :sierra
    sha256 "82e3ee6e9dcafad244f0a0509500afbc714d35beba303fda57bbda00e2cf7fe9" => :el_capitan
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
