class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.5/p11-kit-0.23.5.tar.gz"
  sha256 "0d8fed192563c324bb5ace3c068f06558a5569a6e8eb47eee1cd79ada3b1124f"

  bottle do
    sha256 "f1008afabf2d9454119eaf6aa4b75cc1f1a782d9d6ad7041c1d0a019dda6be05" => :sierra
    sha256 "d8c54b9f80e06bc36fb87a89785986fe5c94a9b193d114f6cf0b5621768399b1" => :el_capitan
    sha256 "7fd6772a1147840eb8974fe0605a3bace98ebeb68cefb72cd71fc08df2ce927f" => :yosemite
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
