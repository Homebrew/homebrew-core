class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/33/ngspice-33.tar.gz"
  sha256 "b99db66cc1c57c44e9af1ef6ccb1dcbc8ae1df3e35acf570af578f606f8541f1"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 "b00fa22144c9add0b27a0c169e51877fb680ae309f0b339043898cb7c1be8a22" => :big_sur
    sha256 "1e9280810ac216eefca4dbff61d8ed764feca6c9c4103195f3894eae0918b25e" => :arm64_big_sur
    sha256 "947aa81277b9bfdfe5b9a52ba502f146cb2c7e5125e88770255a40f6799685bd" => :catalina
    sha256 "0d880665db391a48e55b133b6fea6cbf7f0e56c0428045b4d046b03dfff95685" => :mojave
    sha256 "9f048cc3f136b84cfd2f76afe91f39d7bf844c00e442a9fbb7363f84fa44a8c7" => :high_sierra
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
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
