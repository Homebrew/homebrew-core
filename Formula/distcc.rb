class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.4/distcc-3.4.tar.gz"
  sha256 "2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/distcc/distcc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "8eb63057e2dfe3c30167c9e4bdae8c3b95adb0e49d0107587df14084053a3b95"
    sha256 arm64_big_sur:  "ffab1cecd8e01d68b0219b5a6bfe5ff17951b56721e22e43c98e5195d25a0478"
    sha256 monterey:       "d8c6cdd1435d7bb44b6ada902e509765ea6a270b4e7a6b8d77d723531d3878eb"
    sha256 big_sur:        "18a8fd773714b43e5effec750afca17ff2c55c29cfcfbf43a70da804d0387be8"
    sha256 catalina:       "eeb7573a412908530b6deec90e1a8dea6d6e8ca543914ccdc8aa93cf390cacad"
    sha256 mojave:         "a2ed5a4d9b741a95a0ff3bb710f7382b6d3b4e01c30f6e0e9698da8796291504"
    sha256 x86_64_linux:   "1c5befd01ca2e4c87b074ef98b7d23f33a5b08e9b63e77b71869d4da1b2a7e51"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20210106.orig.tar.xz"
    sha256 "9df153d69914c0f5a9145e0abbb248e72feebab6777c712a30f1c3b8c19047d4"
  end

  def install
    # While libiberty recommends that packages vendor libiberty into their own source,
    # distcc wants to have a package manager-installed version.
    # Rather than make a package for a floating package like this, let's just
    # make it a resource.
    buildpath.install resource("libiberty")
    cd "libiberty" do
      system "./configure"
      system "make"
    end
    ENV.append "LDFLAGS", "-L#{buildpath}/libiberty"
    ENV.append_to_cflags "-I#{buildpath}/include"

    # Make sure python stuff is put into the Cellar.
    # --root triggers a bug and installs into HOMEBREW_PREFIX/lib/python2.7/site-packages instead of the Cellar.
    inreplace "Makefile.in", '--root="$$DESTDIR"', ""
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  service do
    run [opt_bin/"distcc", "--allow=192.168.0.1/24"]
    keep_alive true
    working_dir opt_prefix
  end

  test do
    system "#{bin}/distcc", "--version"
  end
end
