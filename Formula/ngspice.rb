class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/27/ngspice-27.tar.gz"
  sha256 "0c08c7d57a2e21cf164496f3237f66f139e0c78e38345fbe295217afaf150695"

  bottle do
    sha256 "267664560fe26b818457e00ba124ad1951b452ad978bd34ee7d7b9f4567bd3b9" => :sierra
    sha256 "b508b0ca4f88db18b48796715a9de16ee5e7c119b13809ce01a87685f3a9393e" => :el_capitan
    sha256 "ea1f0b65fcb3bb926124694d210e14800be6e47e73dcbf47a8e2baaac5314f44" => :yosemite
    sha256 "4bc737b0801c82999a290f602f416de0ed38777df599afc688d9695c1f16d704" => :mavericks
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
    (testpath/"test.cir").write <<-EOS.undent
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
