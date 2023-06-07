class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.5.1/libjpeg-turbo-2.1.5.1.tar.gz"
  sha256 "2fdc3feb6e9deb17adec9bafa3321419aa19f8f4e5dea7bf8486844ca22207bf"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  # Versions with a 90+ patch are unstable (e.g., 2.1.90 corresponds to
  # 3.0 beta1) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(%r{url=.*?/libjpeg-turbo[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24657182233e7669e645d675a7a954f277510c9de37fdbeedbeee777246cdaea"
    sha256 cellar: :any,                 arm64_monterey: "844f7f6b0883d91c6e5f16c2c752d05566cea571def6f262b580c6d35a928e14"
    sha256 cellar: :any,                 arm64_big_sur:  "9f88f50b6fb148d2edc5dd9138ee78e9d9c1a0f075e311b3a1398c6e43ca07df"
    sha256 cellar: :any,                 ventura:        "776ff10759a35f1ad39676e3a77ee25d88ae4d50fe31935fdba0fe197e455962"
    sha256 cellar: :any,                 monterey:       "203e5e3e6f9f53e16f532d9019c16c88dcbc411a06cc29a98e4e993f64377e0f"
    sha256 cellar: :any,                 big_sur:        "88632579a1730a7be4ad57d23e46b54c522d2ae511c9184fae81612fc349e596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d6d5a7ca948d8dc163f5a1f163ef097b63266a41e5dbddd88f41918d3a3698"
  end

  depends_on "cmake" => :build

  on_intel do
    # Required only for x86 SIMD extensions.
    depends_on "nasm" => :build
  end

  # These conflict with `jpeg`, which is now keg-only.
  link_overwrite "bin/cjpeg", "bin/djpeg", "bin/jpegtran", "bin/rdjpgcom", "bin/wrjpgcom"
  link_overwrite "include/jconfig.h", "include/jerror.h", "include/jmorecfg.h", "include/jpeglib.h"
  link_overwrite "lib/libjpeg.dylib", "lib/libjpeg.so", "lib/libjpeg.a", "lib/pkgconfig/libjpeg.pc"
  link_overwrite "share/man/man1/cjpeg.1", "share/man/man1/djpeg.1", "share/man/man1/jpegtran.1",
                 "share/man/man1/rdjpgcom.1", "share/man/man1/wrjpgcom.1"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_JPEG8=1", *std_cmake_args(install_libdir: lib)
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "test"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose",
                           "-perfect",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
    assert_predicate testpath/"out.jpg", :exist?
  end
end
