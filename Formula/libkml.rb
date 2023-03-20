class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://github.com/libkml/libkml"
  url "https://github.com/libkml/libkml/archive/refs/tags/1.3.0.tar.gz"
  sha256 "8892439e5570091965aaffe30b08631fdf7ca7f81f6495b4648f0950d7ea7963"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d706cf51e6e9b850bba757a87810f659786a9ecde9caa9c954ea0a961c06db5"
    sha256 cellar: :any,                 arm64_monterey: "f7eab34add1f413ba5c0064e7e25cbfb998d2661546d6dc333010c9aad8ae3b7"
    sha256 cellar: :any,                 arm64_big_sur:  "49627d8a08d0204887b6aaf9504f96d445baa432e2d4194f10165b207325075d"
    sha256 cellar: :any,                 ventura:        "40b963c5f6126f16d16531ffcb0b63ff36c75a7e4ccfa606a7adc373d9efa0e5"
    sha256 cellar: :any,                 monterey:       "3e4d4a663b1fdf137b7e9347776b0f58b447124a39e0271fd9dd90b5209beb9c"
    sha256 cellar: :any,                 big_sur:        "8a2252b7f4e4ea322abbd86f9af02780d838c22103f9b562d64c03136e1549a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a8cdd08aa6620f894eae9b3bd37184bb08f25800aba660c234320e4b51ef75"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :test
  depends_on "pkg-config" => :test
  depends_on "boost"
  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "kml/regionator/regionator_qid.h"
      #include "gtest/gtest.h"

      namespace kmlregionator {
        // This class is the unit test fixture for the KmlHandler class.
        class RegionatorQidTest : public testing::Test {
         protected:
          virtual void SetUp() {
            root_ = Qid::CreateRoot();
          }

          Qid root_;
        };

        // This tests the CreateRoot(), depth(), and str() methods of class Qid.
        TEST_F(RegionatorQidTest, TestRoot) {
          ASSERT_EQ(static_cast<size_t>(1), root_.depth());
          ASSERT_EQ(string("q0"), root_.str());
        }
      }

      int main(int argc, char** argv) {
        testing::InitGoogleTest(&argc, argv);
        return RUN_ALL_TESTS();
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs libkml gtest").chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags, "-std=c++14", "-o", "test"
    assert_match("PASSED", shell_output("./test"))
  end
end
