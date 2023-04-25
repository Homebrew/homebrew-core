class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/40/ngspice-40.tar.gz"
  sha256 "e303ca7bc0f594e2d6aa84f68785423e6bf0c8dad009bb20be4d5742588e890d"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "b50abb56b1275031efec85f77040673e06863541a8e6614e87ab230454641f22"
    sha256 arm64_monterey: "dbcb4e346292bde2427661ffb4116b3a9b2cea0292ea44be8210d45fb5f4cb16"
    sha256 arm64_big_sur:  "e29ab21f16e3e16f7412291c7c0cad9c812ae2496e59c150b759a8b3d4e84195"
    sha256 ventura:        "4c3901f4a2e557787ede17558af36d3a9854a890c8110170c300c37adc5c1d40"
    sha256 monterey:       "23023b8b6d7077f0f32a16cf8564efa4ffcb059b05fc985ec2432e804f2126ed"
    sha256 big_sur:        "4910cf0ed17fa9d0e237848b525a72879c1222229f2385ea84dc25f4db671776"
    sha256 x86_64_linux:   "0492961d5b4fc1aabb0d9ad7be95f8018236e0ed683d7e8e522877fed1495d7d"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "libngspice"
  depends_on "readline"

  def install
    system "./autogen.sh"

    args = %w[
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *std_configure_args, *args
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
