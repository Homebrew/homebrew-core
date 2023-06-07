class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.2.tar.gz"
  sha256 "a50c265a8630e61606567d153d3c70025aa958a28473a2411585b96894be7720"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ade690f9248fe8e68772b1e2c271c130a214e78265e6038940ccc156c4864d41"
    sha256 cellar: :any,                 arm64_monterey: "04e58dfbae68833d152b45985e139cd36014f8d760cbdb94b3879e7ed8e0a106"
    sha256 cellar: :any,                 arm64_big_sur:  "0508b50b5b58488c9d28fdd74789e78ef8ac6335c6766475d5a127c8b6f52d03"
    sha256 cellar: :any,                 ventura:        "9e78fafeec79e41e78e7099d444e0ac7dae06493cbc0c0b427403e202efdde88"
    sha256 cellar: :any,                 monterey:       "6d90266841167e4ef83df3888400711aaf042102e4441ec92b6259288f38ec63"
    sha256 cellar: :any,                 big_sur:        "7ec6630326f1e03da4a279b54ffe31f834b60cfb1367a628a3ff297589b40a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a03a541043ffd69eed0c5aadc4f7660e571cde0c79d42d40c1b9b3adf26f63"
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
