class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.4/libaec-v1.1.4.tar.bz2"
  sha256 "cf869c166656a83857adf62a092311a0069855c6ced3446e3f090a6d52279f65"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b7cf987f0fdd72e90def1d0245c06e99edc300e9f7d3eaa01187700a1158742"
    sha256 cellar: :any,                 arm64_sonoma:  "10ba88e1ad1c0309d6c44229401b566943f99834bad2e1e77144e5ddf935907d"
    sha256 cellar: :any,                 arm64_ventura: "1d649a7e55b9f968ef794f97b48a391f736c3febd3b7cc317d324a3f45d3ef39"
    sha256 cellar: :any,                 sonoma:        "dc39d915e139bffd788f2a8c97b5af10867f2ab06e7cca0d2c2a675178c3b1f6"
    sha256 cellar: :any,                 ventura:       "1e1ec34fb1397f13a0dcd56cce603bf6ae60770c6e8ae3e553f96c129382c493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5cb6a131e3f0e724ab22b11888efbde54a79387a07ae0e06fb7ecd39d320fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d100dbf43575d7c8807c4c862ae757f3a19278ddf0defe047213c66189840a34"
  end

  depends_on "cmake" => [:build, :test]

  # These may have been linked by `szip` before keg_only change
  link_overwrite "include/szlib.h"
  link_overwrite "lib/libsz.a"
  link_overwrite "lib/libsz.dylib"
  link_overwrite "lib/libsz.2.dylib"
  link_overwrite "lib/libsz.so"
  link_overwrite "lib/libsz.so.2"

  def install
    # run ctest for libraries, also added `"-DBUILD_TESTING=ON` in the end as
    # `std_cmake_args` has `BUILD_TESTING` off
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"

    # Symlink CMake files to a common linked location. Similar to Linux distros
    # like Arch Linux[^1] and Alpine[^2], but we add an extra subdirectory so that
    # CMake can automatically find them using the default search procedure[^3].
    #
    # [^1]: https://gitlab.archlinux.org/archlinux/packaging/packages/libaec/-/blob/main/PKGBUILD?ref_type=heads#L25
    # [^2]: https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/libaec/APKBUILD#L43
    # [^3]: https://cmake.org/cmake/help/latest/command/find_package.html#config-mode-search-procedure
    (lib/"cmake").install_symlink prefix/"cmake" => "libaec"
  end

  test do
    # Check directory structure of CMake file in case new release changed layout
    assert_path_exists lib/"cmake/libaec/libaec-config.cmake"

    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cstddef>
      #include <cstdlib>
      #include <libaec.h>
      int main() {
        unsigned char * data = (unsigned char *) calloc(1024, sizeof(unsigned char));
        unsigned char * compressed = (unsigned char *) calloc(1024, sizeof(unsigned char));
        for(int i = 0; i < 1024; i++) { data[i] = (unsigned char)(i); }
        struct aec_stream strm;
        strm.bits_per_sample = 16;
        strm.block_size      = 64;
        strm.rsi             = 129;
        strm.flags           = AEC_DATA_PREPROCESS | AEC_DATA_MSB;
        strm.next_in         = data;
        strm.avail_in        = 1024;
        strm.next_out        = compressed;
        strm.avail_out       = 1024;
        assert(aec_encode_init(&strm) == 0);
        assert(aec_encode(&strm, AEC_FLUSH) == 0);
        assert(strm.total_out > 0);
        assert(aec_encode_end(&strm) == 0);
        free(data);
        free(compressed);
        return 0;
      }
    CPP

    # Test CMake config package can be automatically found
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)

      find_package(libaec CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test libaec::aec)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
