class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/38/ngspice-38.tar.gz"
  sha256 "2c3e22f6c47b165db241cf355371a0a7558540ab2af3f8b5eedeeb289a317c56"
  license :cannot_represent
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "9afdd51fb80afff3464c0ff2d948572e24dd05d2689b43abcc574511465883ca"
    sha256 arm64_monterey: "0d89f5e8f521a30c746b79a5a4f57a411494fd47675bb51c6e329a2b2ee8bc98"
    sha256 arm64_big_sur:  "33242e4c484ac677776491f8c2c99c11398c06df9af897fe929125ead3c39d6a"
    sha256 ventura:        "6449cdb3ae635bbf199e543721f9b8293a6d2a3d118b3e356c7b51c092bd1e05"
    sha256 monterey:       "d6d0d6a6594814949a254e880f4ef225556c14405d886e02bbf2c1d91fea5676"
    sha256 big_sur:        "568d6aaff7cd1ce017a5db965ad8a7021d47abcd8fd714e0b60e35cfe1fc9572"
    sha256 catalina:       "eb46b27dbfacc9d9f3dd1324a2485f1ef35a9ab7eb2ae17d513bee9eae5ee0c5"
    sha256 x86_64_linux:   "93c269ce998cb2f96e5de41c4fc0a78f484808c7355e43a58f61939a5bffea3d"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "libngspice"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?

    args = %w[
      --disable-dependency-tracking
      --disable-silent-rules
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
