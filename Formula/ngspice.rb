class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/28/ngspice-28.tar.gz"
  sha256 "94804fa78c8db2f90f088902e8c27f7b732a66767a58c70f37612bff5a16df66"
  revision 1

  bottle do
    sha256 "42896bc07cf06a7aba74d22340e68453d9dc09adae82a2d56ba95d80276d0a97" => :mojave
    sha256 "a5a641e0cc5305b7741dbdfbb18230e71d8ae3add7ed314c85ac801a48424cb2" => :high_sierra
    sha256 "e2276123df61e171bda40781e5db332befba04f0c75dfdb97b4b57ffeb8fa7b9" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "with-x" => "with-x11"

  depends_on "readline"
  depends_on :x11 => :optional

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=yes
      --enable-xspice
    ]
    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

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
