class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230802.0.tar.gz"
  sha256 "59d2976af9d6ecf001a81a35749a6e551a335b949d34918cfade07737b9d93c5"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4e2023168ab5b81f85eba33843cdd18340a7125736b647c70b92707b0c7dc72"
    sha256 cellar: :any,                 arm64_monterey: "ffcb785b1e7f4572aff37b86133a23123cd1082df8577e4de3d3b9029dac533e"
    sha256 cellar: :any,                 arm64_big_sur:  "a688da1f40effea98c6e46e26e87ea9313b195582f7a41ad4ea135202e954ecd"
    sha256 cellar: :any,                 ventura:        "39f69ab5e46934041193e8c3a1ae9f5c329a970f8378622eb7ea377c49c39ac3"
    sha256 cellar: :any,                 monterey:       "d7084bd4ec3413a4f7f7bf48823940a03543471a868cec396ab76e13da78b4e9"
    sha256 cellar: :any,                 big_sur:        "6aa6d4c0b2dacd362ceaf6df59f3c9846de4880d0d8b081158d2d81885cd3d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3de5351e19b6dda81c61265ef3fc2f0452a08cc307477e8c0c8debbd477351d"
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
