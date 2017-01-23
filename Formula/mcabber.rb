class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.0.4.tar.bz2"
  sha256 "63b6bc003fcceba4dc4b273ed1c71643c4f8d95e8696543d53f64a7672b1ce0a"

  bottle do
    rebuild 1
    sha256 "460e270af0a1e05b242197a2c967d6065680830376f845409062fdc9377485ec" => :sierra
    sha256 "f582dc53fe2e9b1f317885d069ccc1b5ebea671f992bd373223a2d37c998ba23" => :el_capitan
    sha256 "9077d7c748da6ef614f8f0a7c472c32dd9b529c3f759645439f90436215650a5" => :yosemite
    sha256 "edf7c7f55d5d688594052203aa0341285faa4c128cf4274a525520d41f50a3e5" => :mavericks
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
