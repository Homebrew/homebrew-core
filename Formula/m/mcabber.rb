class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.2.tar.bz2"
  sha256 "c4a1413be37434b6ba7d577d94afb362ce89e2dc5c6384b4fa55c3e7992a3160"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?mcabber[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "22148b4dac302fc1e66326cd0a1790831aa8b2a1fe8911b41944125056d2cd20"
    sha256 arm64_sonoma:   "4360dd97e2380a7f382a3b7c2ca1a0e75525b6611c72f28e65709cafe6b30bb1"
    sha256 arm64_ventura:  "7815be33fdbe1617a9bd769ddcefb123668d13957690faf188608d569570242e"
    sha256 arm64_monterey: "7e1900fb7c58c6a948cb2329a3e52f9dcdf7fe69afa5519cc7d8b096db950c31"
    sha256 sonoma:         "5d40492fc3afb54bcce4b07f51feb4139af51e968ad0b70a876fd36a33e77df3"
    sha256 ventura:        "0ba512ce535bed85a080c9117179e67e9e7f49243b02989a7b09456d0f50faa3"
    sha256 monterey:       "498e9db79846d370de50a85ce3eef354bc27b6f6a6ea7ecd43008a65a3d7eef2"
    sha256 arm64_linux:    "c60a7ff2bca6ab6ecf15c6d362a8910042f63d1bec9221a19b3146416cc1913f"
    sha256 x86_64_linux:   "9dd90456ae959bdf7893656a4ab0177937fc9d25f618a753a54e5730095d18b8"
  end

  head do
    url "https://mcabber.com/hg/", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "loudmouth"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libassuan"
    depends_on "libgpg-error"
  end

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--enable-otr", *std_configure_args
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
    system bin/"mcabber", "-V"
  end
end
