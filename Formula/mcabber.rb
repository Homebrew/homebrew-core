class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.0.tar.bz2"
  sha256 "04fc2c22c36da75cf4b761b5deccd074a19836368f38ab9d03c1e5708b41f0bd"

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
