class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/45/ngspice-45.tar.gz"
  sha256 "f1aad8abac2828a7b71da66411de8e406524e75f3066e46755439c490442d734"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "e1fbc716699bedd11ac0040cafb2d54fc7765d164f432f99e9a5b32751934330"
    sha256 arm64_sonoma:  "696062f1262576c544cc2946d8297a467019e7fbc3209289ab380718ac83a9d0"
    sha256 arm64_ventura: "16f6bdf8892dbf381e4821c695b9cd3e29c102b167fec621f71009a31def195b"
    sha256 sonoma:        "1f1d40b5cf95971d18d44d64de9422d493a7defc5eef7600daa2de3bd7af304a"
    sha256 ventura:       "e918e90c17a14c699bbd5985d69fa1a56f916aacba200bc82fe298e52df45268"
    sha256 arm64_linux:   "959ef6bd9de4cef70e5dd50111aa46864c7101832bd1e5db86a408f630af4d24"
    sha256 x86_64_linux:  "b39aff234f3c3b2f7520ed58837b70778c619dba4a56b9d4f29c3157bb99f482"
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
