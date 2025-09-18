class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.2/libjpeg-turbo-3.1.2.tar.gz"
  sha256 "8f0012234b464ce50890c490f18194f913a7b1f4e6a03d6644179fa0f867d0cf"
  license all_of: [
    "IJG", # libjpeg API library and programs
    "Zlib", # libjpeg-turbo SIMD source code
    "BSD-3-Clause", # TurboJPEG API library and programs
  ]
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6256a7912f1779ffa22ad0a810bd2e87010aaf1ff16d8940a874240d47181f0d"
    sha256 cellar: :any,                 arm64_sequoia: "59f90f6a9c2dc28abc3b425c7116e30dc4c13986538c6fcf614fa1b2aee8e7d4"
    sha256 cellar: :any,                 arm64_sonoma:  "1c5e9b9ef5e17f4f0fc2106af7542a88504514732093a8b61a36719c57e4c9a7"
    sha256 cellar: :any,                 arm64_ventura: "eb4dfded7634a24975783260114ea16343d61628a0cc6ab3f570a34652322ef9"
    sha256 cellar: :any,                 sonoma:        "90085add5a101d6955ca901a3b42461886d5b2430f705ac93406f87bba332be1"
    sha256 cellar: :any,                 ventura:       "b803551f9cbecfe086529fef00074ab62379eba3d4cdbdcf91cd2aa72e440463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6df4b965f4213f3bb467e67234e17a936e7bbc94a3dd3978bbd30da88063988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975be8b75336be29123f54241bd2d8a69f8cdf90c211bac3b3f2fe71efd3dac4"
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
    if Hardware::CPU.arm? && OS.mac?
      if MacOS.version >= :ventura
        # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/709
        args += ["-DFLOATTEST8=fp-contract",
                 "-DFLOATTEST12=fp-contract"]
      elsif MacOS.version == :monterey
        # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/734
        args << "-DFLOATTEST12=no-fp-contract"
      end
    end
    args += std_cmake_args.reject { |arg| arg["CMAKE_INSTALL_LIBDIR"].present? }

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace [lib/"pkgconfig/libjpeg.pc", lib/"pkgconfig/libturbojpeg.pc"],
              prefix, opt_prefix
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose",
                           "-perfect",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
    assert_path_exists testpath/"out.jpg"
  end
end
