class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.13.tar.gz"
  sha256 "890c57c558d58708e55828ae299245bd2763318acf53e456a48aac883ecfe67d"

  bottle do
    sha256 "893e8854c92794377f2fc0b6cd96ad7f7ffd3d153a0a1678c6227468067d3696" => :mojave
    sha256 "f1feaf922ae9105c64ba207bc9e2d9b573ddcae8b6feaba501a6daf3068e9901" => :high_sierra
    sha256 "a9ca5fff16a7aa506e2067d7bad9bbb8c54ede7af0e1102150f5d385a7097e9d" => :sierra
    sha256 "cf3d8203cb207792e0c800aadc86ee78714795316e936870f5a4ceae53bfdacc" => :el_capitan
  end

  head do
    url "https://github.com/hercules-390/hyperion.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    system "make"
    system "make", "install"
    pkgshare.install "hercules.cnf"
  end

  test do
    (testpath/"test00.ctl").write <<~EOS
      TEST00 3390 10
      TEST.PDS EMPTY CYL 1 0 5 PO FB 80 6080
    EOS
    system "#{bin}/dasdload", "test00.ctl", "test00.ckd"
  end
end
