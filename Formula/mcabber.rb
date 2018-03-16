class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.0.tar.bz2"
  sha256 "04fc2c22c36da75cf4b761b5deccd074a19836368f38ab9d03c1e5708b41f0bd"

  bottle do
    sha256 "c95601a98c1c0a3ee247ccfef25d77b52d49ebd535840761916225571a9c3ebe" => :high_sierra
    sha256 "b3bdcaf2f025e9b8844fd8b0be4ccbb742b088987658724d1599714fb053b9ca" => :sierra
    sha256 "221b163a3c4634bad784d29c7590a87984d662de7a38ea1fc2d5fc2ff3306eb4" => :el_capitan
    sha256 "3bfcbb80e1e4bebe963f88b8045a1dcea0cd3e3bed2e79a62b69d7cafc9c7e21" => :yosemite
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

  def caveats; <<~EOS
    A configuration file is necessary to start mcabber.  The template is here:
      #{opt_pkgshare}/mcabberrc.example
    And there is a Getting Started Guide you will need to setup Mcabber:
      https://wiki.mcabber.com/#index2h1
    EOS
  end

  test do
    system "#{bin}/mcabber", "-V"
  end
end
