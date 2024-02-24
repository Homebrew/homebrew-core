class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240116.1.tar.gz"
  sha256 "3c743204df78366ad2eaf236d6631d83f6bc928d1705dd0000b872e53b73dc6a"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c0ce0bf7a814050604e08e7cca584796e9ad6c6f9c144482723cf2078530ae4"
    sha256 cellar: :any,                 arm64_ventura:  "8ca7bf42d9c171c4ee7c8820d4ea06d9844500f6175567b69af41c6b0d0aed1b"
    sha256 cellar: :any,                 arm64_monterey: "c6d08c6b6527e1690fb90422a0ac3f68e3b2690f32d33f2ca6dc6544b95d713b"
    sha256 cellar: :any,                 arm64_big_sur:  "a4cdc8226142f6c4e60269e37fd5c72158557bc72b259375dc98bcdedcc040a1"
    sha256 cellar: :any,                 sonoma:         "196cccb369bee0da7792576f6dbd81f09e61000719eb55007d9170fd689fc46c"
    sha256 cellar: :any,                 ventura:        "4b0d382639cafe5d893cbd94f9b81d9f5bebee71137ac81ed776d61692a2d603"
    sha256 cellar: :any,                 monterey:       "318281ca65382113d62cd3fb6abc9c72dfc9b3ff29a4cbed5a98c96a02fea967"
    sha256 cellar: :any,                 big_sur:        "f27b84a7ecd0a042f2539376bceb9c51873a41f5f67f7d0c07f253f25bb96e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cab757ec3d44569b025395324cb53f09f4384129ed913fe7ceb0b48ec0a3d76"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "googletest" => :build # For test helpers
  end

  fails_with gcc: "5" # C++17

  def install
    ENV.runtime_cpu_detection

    # Install test helpers. Doing this on Linux requires rebuilding `googltest` with `-fPIC`.
    extra_cmake_args = if OS.mac?
      %w[ABSL_BUILD_TEST_HELPERS ABSL_USE_EXTERNAL_GOOGLETEST ABSL_FIND_GOOGLETEST].map do |arg|
        "-D#{arg}=ON"
      end
    end.to_a

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DABSL_PROPAGATE_CXX_STD=ON",
                    "-DABSL_ENABLE_INSTALL=ON",
                    *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # Remove bad flags in .pc files.
    # https://github.com/abseil/abseil-cpp/issues/1408
    inreplace lib.glob("pkgconfig/absl_random_internal_randen_hwaes{,_impl}.pc"),
              "-Xarch_x86_64 -Xarch_x86_64 -Xarch_arm64 ", ""
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-labsl_strings",
                    "test.cc", "-o", "test"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/test")
  end
end
