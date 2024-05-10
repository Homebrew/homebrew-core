class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/42/ngspice-42.tar.gz"
  sha256 "737fe3846ab2333a250dfadf1ed6ebe1860af1d8a5ff5e7803c772cc4256e50a"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "8b00c132aa7e3a906ee9cecdf333ab5e59f82783c3d0d8e184396b6ee8577c5b"
    sha256 arm64_ventura:  "cceb4f32c6a156424548eaf8ce49a5946f4f23b84e46b7170505546dd60e9f5c"
    sha256 arm64_monterey: "371b01ab45cf8603bdf03eceb32741ab38492c12a3d4e92a721b86a25ed9fc50"
    sha256 sonoma:         "920f3bd5d9c962f0bc865dc638639d69999960ff135ee89b6eeae2eccb5ee4f7"
    sha256 ventura:        "ebee9d74756146592ef5f0da5e9e58ecd168578725602c35ead01151977d9b18"
    sha256 monterey:       "fc2a58981985f9352528ca2c1e01a438b4eaaad4c681ea8ad283b2441a9c6e80"
    sha256 x86_64_linux:   "3677db1c4522b4cff1c6d95aa5cca015e1bd4839744d003799bfd28526a5638e"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "libngspice"
  depends_on "readline"

  uses_from_macos "bison" => :build

  def install
    system "./autogen.sh" if build.head?

    args = %w[
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # fix references to libs
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", Formula["libngspice"].opt_lib/"ngspice/"

    # remove conflict lib files with libngspice
    rm_rf Dir[lib/"ngspice"]
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
    system "#{bin}/ngspice", "test.cir"
  end
end
