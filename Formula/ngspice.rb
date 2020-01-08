class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/31/ngspice-31.tar.gz"
  sha256 "845f3b0c962e47ded051dfbc134c3c1e4ac925c9f0ce1cb3df64eb9b9da5c282"

  bottle do
    sha256 "2cf8213afe30a3562ff07df2b647eb92c3f6c397b905a4c87641ea9b6ee96ec2" => :catalina
    sha256 "2b4e0e156007ec72197895802c8068c4de19f4cad2a1de3d8a235b88cd46136a" => :mojave
    sha256 "949704c51d5378a5f168db3a504d8b94de7c6a3bec7ae8e671b5267999dacf6d" => :high_sierra
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
