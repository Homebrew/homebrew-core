class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/37/ngspice-37.tar.gz"
  sha256 "9beea6741a36a36a70f3152a36c82b728ee124c59a495312796376b30c8becbe"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "6421f66dabcafb24914972884fc7e4ff4dfd2919b0898864ad2580e9528d5c4b"
    sha256 arm64_big_sur:  "9222829c0bfa71e306e073be15f9c4976dfa105480b618c842823978d3cf4e23"
    sha256 monterey:       "80a8fc2742bca92a86cb22062ad7dfb1180769ec185be23807e48ae009f92143"
    sha256 big_sur:        "9e0a218271ee9b1491d4e896c77905589d44464c13a99db0b946a38068583e6e"
    sha256 catalina:       "f67eb8cb4eddb299a848a22e2507cf3fdb775b17f15dd1c5451186fc1387ab4c"
    sha256 x86_64_linux:   "27e1a76a94f39071ef949f848ed17d7a59b3a0db7c2d444f846b5f1e85e0ce2c"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

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
