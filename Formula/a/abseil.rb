class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240116.1.tar.gz"
  sha256 "3c743204df78366ad2eaf236d6631d83f6bc928d1705dd0000b872e53b73dc6a"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d4e420f6cbe5173bb119eccc8dc1e8c157910960572c320b492fa2b86fbfd15"
    sha256 cellar: :any,                 arm64_ventura:  "c8b3c00165314428a961270c155f99293da118ce6e3f5168d53197d802666c65"
    sha256 cellar: :any,                 arm64_monterey: "5e755850a1f19269b6d437a5664c2dac11ae8dc3b6524c79c3948a6529382a34"
    sha256 cellar: :any,                 sonoma:         "1a341bebdc6e3100bcf70854e74eb50a75e20aaf4026500d014abe8ebf5042bf"
    sha256 cellar: :any,                 ventura:        "6fe66ac0982beac4e53472c17e1058d57cd83aceac7cbd7a44156f5ac181cb3f"
    sha256 cellar: :any,                 monterey:       "c78fb6bcee52344a1e80eb9262b379ac29665692e6d59eef8f1c103503d921b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d11d4048802f83a1fd97656df8c105b60c3433523542a51a8cd4d0cb5d24a2"
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
