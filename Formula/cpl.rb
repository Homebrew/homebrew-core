class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.2.2.tar.gz"
  sha256 "65e7670729fe6a03f8bcf6b8140cdaf101f471a1a3a4d426811fa2f22cf89a4c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "59fda22c52d9add0cf27375ccab8061209128acae99ad53e115b7616d37a2a14"
    sha256 cellar: :any,                 arm64_big_sur:  "f98316577f5d261a64c081fb436f9cd4666c145aee21899b7aa9225921bb5b35"
    sha256 cellar: :any,                 monterey:       "3a378d521c7f300e3bf554f2a26532b3d46ebe72a50e74c4b32dcf2a8ac30c58"
    sha256 cellar: :any,                 big_sur:        "5acda25a5ce54b2f761783907678cc1817f4d65183fb710db67d1967a36fe19b"
    sha256 cellar: :any,                 catalina:       "555f4f3bca9f72dcda5eac44ea5b6a27f83eb04ad592a27f76b185cbc4370f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f308c57ae47f8bb9b581ca6c8a8bd47a2b20efb82ca34f869d02f992308ffb08"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "libcext"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
