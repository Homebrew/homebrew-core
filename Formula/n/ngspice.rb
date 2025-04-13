class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/44.2/ngspice-44.2.tar.gz"
  sha256 "e7dadfb7bd5474fd22409c1e5a67acdec19f77e597df68e17c5549bc1390d7fd"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "1ffc6582d286ba7c1055977a97500cd471eb9f9841c25367fcd1d95732236ef8"
    sha256 arm64_sonoma:  "9552d93ee2085bf77d77231dc028067699663683f109f5ed2c946f54f2d407f6"
    sha256 arm64_ventura: "a2da2fd8087760d6dad8e20002165dca3b131d3905376eaedf70b6d681abc9b6"
    sha256 sonoma:        "f624fb44bf82600cdda20654e6ba1f4fd1b9e5f14f424771fe248160da3a77d1"
    sha256 ventura:       "94a359bbe2d18e22422fbff5d654404e99b1aad7ba98854c9ae686cfe6e0636e"
    sha256 arm64_linux:   "2e59dddfbbbedb1a710590ede896261865481cce64e3e551a3d67850e2a77348"
    sha256 x86_64_linux:  "516b7806491d2da1e788ec6d0fc7074716171ee10d04fdddc004f6cdb7e05ab8"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "freetype"
  depends_on "libngspice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxext"
    depends_on "libxmu"
  end

  def install
    # Xft #includes <ft2build.h>, not <freetype2/ft2build.h>, hence freetype2
    # must be put into the search path.
    ENV.append "CFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    args = %w[
      --enable-cider
      --enable-xspice
      --disable-openmp
      --enable-pss
      --with-readline=yes
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # fix references to libs
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", Formula["libngspice"].opt_lib/"ngspice/"

    # remove conflict lib files with libngspice
    rm_r(Dir[lib/"ngspice"])
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew install --cask xquartz
    EOS
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system bin/"ngspice", "test.cir"
  end
end
