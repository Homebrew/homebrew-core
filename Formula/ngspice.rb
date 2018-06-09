class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/28/ngspice-28.tar.gz"
  sha256 "94804fa78c8db2f90f088902e8c27f7b732a66767a58c70f37612bff5a16df66"

  bottle do
    sha256 "82a3aadf40794f4bf0dd89dbb85af272080768009b5a43e9c2e10e214060a000" => :high_sierra
    sha256 "245e35d1ad12c0b06da9089eb9fe05a51da73aefa8e4840c2dc4f6514c6af902" => :sierra
    sha256 "d220c96f72941f8a05dab330ffdb813f294f37daaffede4292821d1b1ed7d7a0" => :el_capitan
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  option "without-xspice", "Build without x-spice extensions"

  deprecated_option "with-x" => "with-x11"

  depends_on :x11 => :optional

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-editline=yes
    ]
    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end
    args << "--enable-xspice" if build.with? "xspice"

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
