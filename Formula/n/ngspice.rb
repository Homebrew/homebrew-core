class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/43/ngspice-43.tar.gz"
  sha256 "14dd6a6f08531f2051c13ae63790a45708bd43f3e77886a6a84898c297b13699"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "1d5d967e5df8300cf220db5ae8f2c0ebbaa46c640f6daa919f87cb31f3ebb3d6"
    sha256 arm64_sonoma:   "61d50fad34522ba081608dd1f5d3477151079538d84cbb45cd814468df38dc8c"
    sha256 arm64_ventura:  "c190af3e69b3db2dd5e2119fe743c24200f7ff28bc7d2f386b98271dd7a3c7a7"
    sha256 arm64_monterey: "3ac872df0b4ea9bab7548abf20a84122418e9a8d3e3a986a6fd9068f191a3a92"
    sha256 sonoma:         "06006e9371f61df4ab71bee94fd7379f0946c3ae32be242e6156c59449d7ec1b"
    sha256 ventura:        "baf73472e5438f531d3e18075a6cc97f72596657a119ee7346d2de2b779ff5bb"
    sha256 monterey:       "7e76ac150dd468473d8ded260453d9dbf8fe270251ade22e7e68b65757202eb3"
    sha256 x86_64_linux:   "cd2f925a4717f2eff7ad283537ffd58bb02c3fabce3fa77ab8b66a52ea7ff0a1"
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
    system "./autogen.sh" if build.head?

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
