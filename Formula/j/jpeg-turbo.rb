class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.1/libjpeg-turbo-3.1.1.tar.gz"
  sha256 "aadc97ea91f6ef078b0ae3a62bba69e008d9a7db19b34e4ac973b19b71b4217c"
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
    sha256 cellar: :any,                 arm64_sequoia: "61f35eb85379177997d46b2dde6914e46560702c7fc6fb9302a415d6fd8cec58"
    sha256 cellar: :any,                 arm64_sonoma:  "376d4bb4d2c558c1ed260776701516120e0f7ee1017183da0bfc19a1ea04cd2b"
    sha256 cellar: :any,                 arm64_ventura: "1f62cf24962df866f01e118155c7eceba8a292660a25d840a17442b7eeedae64"
    sha256 cellar: :any,                 sonoma:        "c5deecf446ce9684b3f57ad27c34a66dc10937b21427847c3c7306e1d868f0b2"
    sha256 cellar: :any,                 ventura:       "5130a317fb6fccb4ae9bdd9191a8c7f42f402241abf2ac7e99424560c081402b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dbc68d51c7196d3d5b0d45b79ab7d43e3802b80f9505ab55393fb1d4e1931c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf38ebdcc3939399b96702205ae4a37f35b8b672056f0b5a6133fb89b82a95f"
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
