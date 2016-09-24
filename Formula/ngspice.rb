class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "http://ngspice.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz"
  sha256 "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108"

  head do
    url "git://ngspice.git.sourceforge.net/gitroot/ngspice/ngspice"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  bottle do
    sha256 "b508b0ca4f88db18b48796715a9de16ee5e7c119b13809ce01a87685f3a9393e" => :el_capitan
    sha256 "ea1f0b65fcb3bb926124694d210e14800be6e47e73dcbf47a8e2baaac5314f44" => :yosemite
    sha256 "4bc737b0801c82999a290f602f416de0ed38777df599afc688d9695c1f16d704" => :mavericks
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
