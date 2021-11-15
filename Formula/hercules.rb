class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.13.tar.gz"
  sha256 "890c57c558d58708e55828ae299245bd2763318acf53e456a48aac883ecfe67d"
  license "QPL-1.0"

  livecheck do
    url :homepage
    regex(/href=.*?hercules[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "989fec41881653b8d1f7372d4de8447703fba4b2b6880194e5974cdad50b58d9"
    sha256 arm64_big_sur:  "ba4b3fa347d63601909127c94c0a2b1e42d81bbcc154970a18d7dd4ad8b15bba"
    sha256 monterey:       "00df43bff8324b015c01c6cae809d69b911e2c2ba45b0a07a4d3be440daf672b"
    sha256 big_sur:        "c85d96adaa0f5cc5a17d5927d4cd1b44f42003baba3e59ff11cee5ce444512fc"
    sha256 catalina:       "aae09d5616cf146c74bf3bfae69c1490cf920404d75d43c7d8c28ac1aab176b8"
    sha256 mojave:         "3c7535fa1d1e9385c9f2525e40445b931c3768ab611db4e6a2019c7910538c41"
  end

  head do
    url "https://github.com/hercules-390/hyperion.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  skip_clean :la

  def install
    if build.head?
      system "./autogen.sh"
    elsif Hardware::CPU.arm?
      system "autoreconf", "-fvi"
    end

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
