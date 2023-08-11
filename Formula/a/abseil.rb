class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230802.0.tar.gz"
  sha256 "59d2976af9d6ecf001a81a35749a6e551a335b949d34918cfade07737b9d93c5"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c789ff211d0d81fba211ffa4abc0a0e5ce430698ae0e590057cbeeb73d620d15"
    sha256 cellar: :any,                 arm64_monterey: "69def86118e5c3fad60816d0747ddb7909f7da1cfe7f4ed4f2373d2e4ac27fb2"
    sha256 cellar: :any,                 arm64_big_sur:  "6f935264ca89f8cd343e01c38cf3806ec98e8e7c616bcbcfc921082af7320f03"
    sha256 cellar: :any,                 ventura:        "365fd4fef0e37db61c1ae3c83e21c0a6d178a180a8ff94eaa61cce25c6ef84c4"
    sha256 cellar: :any,                 monterey:       "42d1faa5ff28d113705a651d57edcdc29580c8b7c941a9db5f3f06c97306966f"
    sha256 cellar: :any,                 big_sur:        "a621f54dec9a4f409592536179c78e62ca67add70b6a06956a3b2802240a7f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447174d63faf184ec9f0c0b5dcf6cc926a619f74b3a130809383f6ee8b4bb316"
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
