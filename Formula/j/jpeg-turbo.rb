class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/3.0.1/libjpeg-turbo-3.0.1.tar.gz"
  sha256 "22429507714ae147b3acacd299e82099fce5d9f456882fc28e252e4579ba2a75"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  # Versions with a 90+ patch are unstable (e.g., 2.1.90 corresponds to
  # 3.0 beta1) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(%r{url=.*?/libjpeg-turbo[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89b1342d1dd69be94c1e293c8fc0ec5d324cd62f42bc8c3e9049bf5452957e01"
    sha256 cellar: :any,                 arm64_ventura:  "0673df94b246dd4e63e8d80e942fd32e6bbd662eba0134b262e9eb6c5e1e2d88"
    sha256 cellar: :any,                 arm64_monterey: "1ae417c7b858c45796f21a17159f21bde07a0e575318dca1757b92fb3b3e515c"
    sha256 cellar: :any,                 sonoma:         "7794d8c394ab444645e86b87a47a868fe82f16b0dcc13d596f684b62a2661c57"
    sha256 cellar: :any,                 ventura:        "01cea0389ed701926bb4141b810a244f9ac57dc43512855019fdf6f0586018a7"
    sha256 cellar: :any,                 monterey:       "acef2e25ab9ab0d53599d43b9f9043006fc0d071c24f3e7e4ef0128ff16319ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf694df57925d1e267cf9fec76c8495662950fd6008b9e29f9f754c8371320"
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
    if Hardware::CPU.arm? && MacOS.version >= :ventura
      args += ["-DFLOATTEST8=fp-contract",
               "-DFLOATTEST12=fp-contract"]
    end
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/734
    args << "-DFLOATTEST12=no-fp-contract" if Hardware::CPU.arm? && MacOS.version == :monterey
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
