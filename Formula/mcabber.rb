class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.0.4.tar.bz2"
  sha256 "63b6bc003fcceba4dc4b273ed1c71643c4f8d95e8696543d53f64a7672b1ce0a"

  bottle do
    sha256 "332f097236d892b6e87d6106fe90a5e079ff8723f8da120d19fc778f54b070eb" => :sierra
    sha256 "e22c4ccbbdd0123c624ae279e302e70115468fcddaaaf19eca81dc8c7e8d0688" => :el_capitan
    sha256 "12ae77f79d617448a4f3f4f8f47451eea0405214c5cc5f4be8156e48c2d98baa" => :yosemite
  end

  head do
    url "https://mcabber.com/hg/", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "enable-aspell" => "with-aspell"
  deprecated_option "enable-enchant" => "with-enchant"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "loudmouth"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libidn"
  depends_on "aspell" => :optional
  depends_on "enchant" => :optional

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-otr"]

    args << "--enable-aspell" if build.with? "aspell"
    args << "--enable-enchant" if build.with? "enchant"

    system "./configure", *args
    system "make", "install"

    pkgshare.install %w[mcabberrc.example contrib]
  end

  def caveats; <<-EOS.undent
    A configuration file is necessary to start mcabber.  The template is here:
      #{pkgshare}/mcabber/mcabberrc.example
    And there is a Getting Started Guide you will need to setup Mcabber:
      http://wiki.mcabber.com/index.php/Getting_started
    EOS
  end

  test do
    system "#{bin}/mcabber", "-V"
  end
end
