class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/31/ngspice-31.tar.gz"
  sha256 "845f3b0c962e47ded051dfbc134c3c1e4ac925c9f0ce1cb3df64eb9b9da5c282"

  bottle do
    rebuild 1
    sha256 "90ef0a161c54ad7ce33ed9753a556478e0a3f56cf1dc0c15d819ff3583ef5fc2" => :catalina
    sha256 "ad1218af03e9711b74cbf8919b8ef9c77ec216ee43d40648423c5043f4feb393" => :mojave
    sha256 "1241cc934814f62c3abcc148817b1eb10ec84db5a7ec65c7d0f5316e4bb7f831" => :high_sierra
    sha256 "89983540f2878f500431a0bec70dfcc2bcfc695e382499586e7f44189a978caa" => :sierra
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
