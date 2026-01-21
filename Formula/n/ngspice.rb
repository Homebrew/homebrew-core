class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/45.2/ngspice-45.2.tar.gz"
  sha256 "ba8345f4c3774714c10f33d7da850d361cec7d14b3a295d0dc9fd96f7423812d"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "fdf2c82d303c3b5944bdbd049ef15a40c388450879d085479965fd481148ed48"
    sha256 arm64_sequoia: "4f819c80ddd4483301f7e01871aeb3049f9e219e22d315052423bde23ccb242d"
    sha256 arm64_sonoma:  "4226d7fb2762659a85353d5d6bebba7f9c3808a5ade8a0ea4fabe2dff6e8e6b3"
    sha256 arm64_ventura: "bb9832d330e7aa8d6e7642f2b7502af8aa6112b68ea4a2dd6fb0c97154c4492e"
    sha256 sonoma:        "e589ca50ee6186e1ebe7d078df4cab987786504dce9f8e49f21686ffe775fe69"
    sha256 ventura:       "525615c53f2f18720430f273b141d5f0da96a1180232f1838cd2e4418c51d1d0"
    sha256 arm64_linux:   "943fc32abf2e74b11faa47f458a0c39c7789ca041bef2fe1ea5358b95afa67a6"
    sha256 x86_64_linux:  "4825e30255d2c0fdb9d41e374ddf3984eb38f5eaae5e9e1a0439abd425c35eb7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
    odie "check if autoreconf line can be removed" if version > "45.2"
    # regenerate since the files were generated using automake 1.16
    system "autoreconf", "--install", "--force", "--verbose"

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
