class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.2.0/libjpeg-turbo-3.2.0.tar.gz"
  sha256 "6f30092cef9fb839779646608f4ee14ae3cbac989c47fa05e841b0841f09878e"
  license all_of: [
    "IJG", # libjpeg API library and programs
    "Zlib", # libjpeg-turbo SIMD source code
    "BSD-3-Clause", # TurboJPEG API library and programs
  ]
  compatibility_version 1
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "02539b0736cfacdc6c4bb6a7d274d0c5c8b6e1faf9b5bab1e155168961d288aa"
    sha256 cellar: :any, arm64_sequoia: "6dc55edcd33c693e474299ed2bba3c472ac1331cbe300066ec8ef99b88fab17c"
    sha256 cellar: :any, arm64_sonoma:  "3ff48858f9042df4ce6ca4bf4006bae5e46f919037cba077f0c81a1f6e0a288a"
    sha256 cellar: :any, arm64_linux:   "17e9fc799ed71fa8453d35fae0bdec249b015d2ba61d3258c8a4ba2bd47faf86"
    sha256 cellar: :any, x86_64_linux:  "85713cddd87d363f7e772f9ab0db5d4192d6f4ef8793393458601ffdba8a1e07"
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

  deny_network_access!

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
