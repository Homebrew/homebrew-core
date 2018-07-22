class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.12/p11-kit-0.23.12.tar.gz"
  sha256 "58bae22f19db1de1a1103e7ca4149eed6e303e727878c2cd5ea9e6fe445fd403"

  bottle do
    sha256 "9b1b9073d5bc3e1685afa141a9c06ad2735060aedd9d2a09ad26707d32152a67" => :high_sierra
    sha256 "bff76ad09d7833cee05e6a2c36ccdf9882b7e30826087441f8b27481842dc0d2" => :sierra
    sha256 "44fe32b613517bd3cbfac4ca22bd6fedb83543ecfb97388c285877cdd5a714ff" => :el_capitan
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
