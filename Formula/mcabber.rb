class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.0.tar.bz2"
  sha256 "04fc2c22c36da75cf4b761b5deccd074a19836368f38ab9d03c1e5708b41f0bd"
  revision 2

  bottle do
    sha256 "4d9680b14dd136a5b1d70f47d8567fcfa7962eb044e43f2f987bb5797b71c74a" => :catalina
    sha256 "fe6ea0970c446bab941b3d4f0206e75673e112dff88c55b5ee429d18f0c9fd68" => :mojave
    sha256 "55b6b38bfe8d3b924f7eb9b707c3e72324e81d312dd589ec99e283aa567b7ba9" => :high_sierra
    sha256 "4be58f58cf92107259a4cc18cf17480dabbeeb130cfc6a182daca0bf76634ac5" => :sierra
  end

  head do
    url "https://mcabber.com/hg/", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "loudmouth"

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-otr"
    system "make", "install"

    pkgshare.install %w[mcabberrc.example contrib]
  end

  def caveats
    <<~EOS
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
