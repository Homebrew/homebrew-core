class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.7/p11-kit-0.23.7.tar.gz"
  sha256 "988e7c86f2641b36702503481292ef0686e6b1c39d80b215699b6dbf1024be41"

  bottle do
    sha256 "c104a1768db89f1c78742b5a605d220165197cfc92d9ff4a8edf6b0c94cf2aeb" => :sierra
    sha256 "f80786b0575f49b54c20e3e66033ecd2fc6b22847c8255389e9f03030a713f17" => :el_capitan
    sha256 "eac346a32cb85a2b0fc2080491db4d9ad2650113444d1f975def9dd50ec2cabc" => :yosemite
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
