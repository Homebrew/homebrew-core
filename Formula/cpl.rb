class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.1.tar.gz"
  sha256 "54546d763e7f75cb679f711c62bc962211328a35064edb6b9455e306458ebe15"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cdfe3609dc92d5182e9b326200c82a3114e4f367d9177d57b5b3c1b3e98c0688"
    sha256 cellar: :any,                 arm64_monterey: "5fd426dfc5de6c429cd02e062cd1bf6b94e6c5f24c8e72e7deef3c65bc745792"
    sha256 cellar: :any,                 arm64_big_sur:  "d9757db02ceb67dd9f70a3d1db0de863678d44ef9acb58c42d4b343e5d9d1a40"
    sha256 cellar: :any,                 ventura:        "1e386174aa9fdc9ac4e03e7cd28843b6bb0c908d8b6d87867fa1a1f0992850b5"
    sha256 cellar: :any,                 monterey:       "88cb133f3f1233c18abf8505a9f68720763800078a2bd2ac5d91d66022ea82fa"
    sha256 cellar: :any,                 big_sur:        "61e749dcdde769f33f1eacbdfa67afd952184bffde2be756ef45cb60d4058671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e1dd5f8e9ae578b52831a6b18f29498e0479dd8f260e6c7dc7e888d2e9e3909"
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
