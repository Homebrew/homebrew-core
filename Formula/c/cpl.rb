class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.2.tar.gz"
  sha256 "a50c265a8630e61606567d153d3c70025aa958a28473a2411585b96894be7720"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c6ae6b7cb1a84a01d0cf02626e62fa069c69ce1ddd58da71a7dbc650f4c233b5"
    sha256 cellar: :any,                 arm64_sequoia:  "44e6e7500a5c7a392a2b4d6ec6aeb8572da5c72ed27650293780e481d3fd05bf"
    sha256 cellar: :any,                 arm64_sonoma:   "710c0bce11e34ef18dcba1f2c592b82827daa9027a2e6ffdf7a5523db746f4c3"
    sha256 cellar: :any,                 arm64_ventura:  "867112ff76fc10a5a8ccf3871398c4057aba8aac147f0452f4b74e60f30c1417"
    sha256 cellar: :any,                 arm64_monterey: "dc4fd5e0d10ebb4d9d3ae0d4c2138765e28e9185f2810fa9f5397ceb6874d409"
    sha256 cellar: :any,                 arm64_big_sur:  "1546444c73b9c83ad97136d5fe48bcd6bee09dd72ed9de6b8ce650a6cbf28610"
    sha256 cellar: :any,                 sonoma:         "a66a7bc13c9683f48d18ad24928ff5effa8737e61ac08da1717de9bb24d5de24"
    sha256 cellar: :any,                 ventura:        "fc6cfb837a591afec3369fa882e5abbd9d806f9d67ed83bd9f345ce3d89a4415"
    sha256 cellar: :any,                 monterey:       "a74afb54620905b6ae184bf64d73f67713e1016e27f97a6db6b793c72b4ba646"
    sha256 cellar: :any,                 big_sur:        "2fff6fb7574c82deb23328136b2666cd181d864fe09eb42780bea78cf63327a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fcd05867d38798a06a3afcac0afff080e67484785148b6d412031f44a9e44d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90683dbc3fc0a9636c4fe77573a82895cd369ff2449d140a6ba5e84db6d571dc"
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
