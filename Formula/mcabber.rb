class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.0.tar.bz2"
  sha256 "04fc2c22c36da75cf4b761b5deccd074a19836368f38ab9d03c1e5708b41f0bd"
  revision 1

  bottle do
    sha256 "9d764d5cf8465b0fe0f005324e93984e2d5be8be6abea22bbf9729b9bdc7550d" => :mojave
    sha256 "2823cae4b0424e6ee1e3beb912275889e4d25c11f90ce2395b77dc60dcda0b39" => :high_sierra
    sha256 "eec539d040769c20a0515909bf79f65265c22b868c7fffa72a014e54b68a5ccb" => :sierra
    sha256 "349752c0dfc6164a84e41548079657878fd5bd3226ec16df17470ac91f64fb16" => :el_capitan
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
