class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/46/ngspice-46.tar.gz"
  sha256 "a0d1699af1940b06649276dcd6ff5a566c8c0cad01b2f7b5e99dedbb4d64c19b"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "707746ba4112da19e618bfc475485bf703895fbeecd2819587f27be9e074bba4"
    sha256 arm64_sequoia: "1800d5805217fe5a7f04ce961b5be89bb413be572acbe0955efcc88747fa8229"
    sha256 arm64_sonoma:  "1f5af70b57c07daae7439916dc0499152f43bc91ad473c68e6908f1f0c1d9572"
    sha256 sonoma:        "45be55251673886c652749ac40e255aa0dc2f68b89fce315c498bc1b8f3c48dc"
    sha256 arm64_linux:   "083957b2e65f6f74958d43b681799ffecc64ec126f0f0b3bb30fd588dce53642"
    sha256 x86_64_linux:  "c2ea7875c0bf0cc40082aa91dd348fd110b759d292eda53215b741c6882c2c5c"
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
