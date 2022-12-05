class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.2.3.tar.gz"
  sha256 "0b18ae87786d1f9a3cddd841464a6ec2f3339989eea9d5ef84a4b8a1e4ce68da"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "efdf07e7c3c34534215fcb092b91d848caa4eb2b21bb5f35620191f3ff566845"
    sha256 cellar: :any,                 arm64_monterey: "59fda22c52d9add0cf27375ccab8061209128acae99ad53e115b7616d37a2a14"
    sha256 cellar: :any,                 arm64_big_sur:  "f98316577f5d261a64c081fb436f9cd4666c145aee21899b7aa9225921bb5b35"
    sha256 cellar: :any,                 ventura:        "e64c1c74f1d79313e99225f0470f0cc8b4dfb98d015ff605bef24d5aa2dd93c6"
    sha256 cellar: :any,                 monterey:       "3a378d521c7f300e3bf554f2a26532b3d46ebe72a50e74c4b32dcf2a8ac30c58"
    sha256 cellar: :any,                 big_sur:        "5acda25a5ce54b2f761783907678cc1817f4d65183fb710db67d1967a36fe19b"
    sha256 cellar: :any,                 catalina:       "555f4f3bca9f72dcda5eac44ea5b6a27f83eb04ad592a27f76b185cbc4370f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f308c57ae47f8bb9b581ca6c8a8bd47a2b20efb82ca34f869d02f992308ffb08"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

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
