class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  stable do
    url "https://downloads.sourceforge.net/project/libjpeg-turbo/3.0.0/libjpeg-turbo-3.0.0.tar.gz"
    sha256 "c77c65fcce3d33417b2e90432e7a0eb05f59a7fff884022a9d931775d583bfaa"

    # Patch to fix regression test concurrency issue. Remove in next release.
    patch do
      url "https://github.com/libjpeg-turbo/libjpeg-turbo/commit/035ea386d1b6a99a8a1e2ab57cc1fc903569136c.patch?full_index=1"
      sha256 "7389d29c16be16ae23e40f6ac31e78ca366550644ab96810f1e21bece71919bb"
    end
  end

  # Versions with a 90+ patch are unstable (e.g., 2.1.90 corresponds to
  # 3.0 beta1) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(%r{url=.*?/libjpeg-turbo[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af4d480aafde3db4a5029a8a991e91a9f615b1707f3f5e1797475c66beb982d7"
    sha256 cellar: :any,                 arm64_ventura:  "1971c1fa66c2580fa0bfafe5350c6170bfe7395a4e503e7bfe0c69ec2e353010"
    sha256 cellar: :any,                 arm64_monterey: "89da2a33e1e0e66c1fa10acb40e7c632716a79aa1f82c9175f4cd270cd88bc77"
    sha256 cellar: :any,                 arm64_big_sur:  "8365422894438d22ff64db9387c6445ca5c9cbdecda15da0ef018c7fe355eda1"
    sha256 cellar: :any,                 sonoma:         "9615c984a48c42d6bc214c6c9ca272f88f42c8236396b69eb3f838d64abcc2e6"
    sha256 cellar: :any,                 ventura:        "07d7b63893cbdf50c91ec9f3ca7568c774e03c50a8a98d003ee49665b7af0a8f"
    sha256 cellar: :any,                 monterey:       "468dc920dff06894e1a9097a3d522472e0f59218523585ae78abee561eafc5dd"
    sha256 cellar: :any,                 big_sur:        "4ced360a9d7c567dc49ae6dc6370ed92edbeb0ed6917c40bc56aa3ba73e51ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44943f311f5999c84a5f6d3695b0fa96f6f336eb0f50a5a0174df7febf596174"
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
    args = ["-DWITH_JPEG8=1", "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"]
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/709
    args << "-DFLOATTEST12=" if Hardware::CPU.arm? && MacOS.version >= :ventura
    args += std_cmake_args.reject { |arg| arg["CMAKE_INSTALL_LIBDIR"].present? }

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
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
