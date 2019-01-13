class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/30/ngspice-30.tar.gz"
  sha256 "08fe0e2f3768059411328a33e736df441d7e6e7304f8dad0ed5f28e15d936097"
  revision 1

  bottle do
    sha256 "3fe040d87dbefc7c99c284e302ec32090174eaf2f5f1627828f912314f056c10" => :mojave
    sha256 "f98ab7a1785fd27815f3d974eff684c7573881486f5b18d6230ce871ce30dbc6" => :high_sierra
    sha256 "3b8b53596b5ce1d72961220049fa3f9c1b33fb0a57eaac564feb5448ed89cdb7" => :sierra
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
