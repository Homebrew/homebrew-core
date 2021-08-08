class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/35/ngspice-35.tar.gz"
  sha256 "c1b7f5c276db579acb3f0a7afb64afdeb4362289a6cab502d4ca302d6e5279ec"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "b7e6619a5f7f1b951b0464d4fa18cba7a5d933ec85eccbeb47c67cf22f817520"
    sha256 big_sur:       "6f8f86cccb6242f21a09359f1009344acadcd7d7726766327019e4e5a0ad5655"
    sha256 catalina:      "9dd5b4b1e8164e5b35729838237e68c61d44c94c3aa5209e2613e9ab659f3e0d"
    sha256 mojave:        "0003f68a5390917cd6e0c6b5179a22b02f6fccd0b1f4a359ad17cdd831c456ad"
    sha256 x86_64_linux:  "7ea619d3d84a191503ec53a5ee3673ed8c445cff8b782660075d98db51bdf0a2"
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
