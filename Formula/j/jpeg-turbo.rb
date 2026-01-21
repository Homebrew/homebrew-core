class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.3/libjpeg-turbo-3.1.3.tar.gz"
  sha256 "075920b826834ac4ddf97661cc73491047855859affd671d52079c6867c1c6c0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9fe20e744abc20f8b032df797d921daa8ec012ebb36d65f7b1c86673a3d34aef"
    sha256 cellar: :any,                 arm64_sequoia: "b33d21a69c9d9617f0ea4197a9a5f428078f7f0f6e6388151ca1d15210542c07"
    sha256 cellar: :any,                 arm64_sonoma:  "70cb19d30a2b5434e1b00fe63e3a13e61ca093b9558214e2c48009eb3ebfb308"
    sha256 cellar: :any,                 sonoma:        "076c049defe215bdaaedaa5e306c9ca197e735b47a67cf8fec189100e9e4adfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e725ff65dc9cafcfc224bb963e042fa3c1f513419b77715a9a490831e7ab4709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "223b5d3113a1674992de4b8f0666c2e54c29386bb153fec01f1060772810921c"
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
