class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240116.2.tar.gz"
  sha256 "733726b8c3a6d39a4120d7e45ea8b41a434cdacde401cba500f14236c49b39dc"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f81e5b4e59baadeeb034b9e3ab39bfd6fa3452ba040454b20bc7be02f04e3f1"
    sha256 cellar: :any,                 arm64_ventura:  "4df3835a2f07aa349e5642ac25f680a825a9354252882a22119c027667dcf1b9"
    sha256 cellar: :any,                 arm64_monterey: "22261c6210c1f61544c473e07f72fa9b6d8eaa9ff071de86727698678e27fdd0"
    sha256 cellar: :any,                 sonoma:         "8067cb2758fa425cf8f8bb6f54a7ce623adf88dfcada2de56f99cd5e32648037"
    sha256 cellar: :any,                 ventura:        "98ccb8fc65de2133f4ddee9261e5ec9e10d8af5cb5adc58a0f8ddda7465eaa37"
    sha256 cellar: :any,                 monterey:       "51f2422d7012a1de5a8b16a7b443207cefa7d3a9331f14b8c449f4bdbe655b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9047cdcf5ca116319459936eea3e768ab1498b63195a9484cf283bb263ee74f"
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
