class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.13.tar.gz"
  sha256 "890c57c558d58708e55828ae299245bd2763318acf53e456a48aac883ecfe67d"

  bottle do
    sha256 "9b3545470763509a09f2dad1b40ff6df5f9226019ab10fc44d1fab83ab2a6a78" => :high_sierra
    sha256 "3e0b0250e45b945a39af795d08d42f541fb77c39abba510c6f069b8901c4b439" => :sierra
    sha256 "d7e872e32dfb1b648b183725de1290db4b2b8b9ea9b9b895cb517f213b046900" => :el_capitan
    sha256 "d1cee67e5294f4bc32cdb9e4126d75d9313d55aca7f3bb43a3fa96483f45afdf" => :yosemite
    sha256 "fbc13a5fd68642f842d07edf3c7439617e770fdf7b0cf5d1cfcff30a93ac4d33" => :mavericks
  end

  skip_clean :la

  head do
    url "https://github.com/hercules-390/hyperion.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
