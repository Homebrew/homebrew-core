class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.4.tar.gz"
  sha256 "f175a4e7a6935264ef49b39fddf45072c955dfe1c8d11923309f8cc774ba1d24"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7bd4945d10901c4be2374a9c76c270501a88ad14b3ce863cbdb061d421d8c89"
    sha256 cellar: :any,                 arm64_sequoia: "8a8ded93a1d6af1ada80df8b8a0aa08cc338d6e587b62476e2a92fbc949fc3d3"
    sha256 cellar: :any,                 arm64_sonoma:  "10e02dd706fb7ff73c5407060ebad2b0138b73336cfd1fc38f4b861192d3f5d7"
    sha256 cellar: :any,                 sonoma:        "5fbb2b26f3b70c1aee5490d756dbdde490b6e941d35673dc4032c664d3ca871b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a1d9ef2ca93ec15e13e71a6e4d26900fd3cdb6cf9b1ea4223aff8ad4a79ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e9d917280305aa3f23da5feb00622c4a1b222cda539082193cb30a6d323bc00"
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
    (testpath/"test.c").write <<~C
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
