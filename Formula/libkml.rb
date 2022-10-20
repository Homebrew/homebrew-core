class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://github.com/libkml/libkml"
  url "https://github.com/libkml/libkml/archive/refs/tags/1.3.0.tar.gz"
  sha256 "8892439e5570091965aaffe30b08631fdf7ca7f81f6495b4648f0950d7ea7963"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a563610ef8923bbc46478295b172df18acf09807708db7bcc678342f9fc1edcb"
    sha256 cellar: :any,                 arm64_big_sur:  "d821b3e1fe0181c3f0d98b6a75c6499bf62ec07845e7ff408e44fc562d95130e"
    sha256 cellar: :any,                 monterey:       "c1c7f462a02c8e2db02d9066019c26b76b768d996743618ccfe48fd4a11b536c"
    sha256 cellar: :any,                 big_sur:        "9209953f47c04fcca293095e2f3e17bf11116321f9fe6fe2482f7759b8adc83a"
    sha256 cellar: :any,                 catalina:       "c6b04631c27926eba07603f5a2ef77678f9f53f249ea6931f9f08a97f73230ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee9e4dec15a9d674c0cc8404ce5551467bbdc4604ae96d7a82b780e59fb8468"
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
    system ENV.cxx, "test.cpp", *pkg_config_flags, "-std=c++11", "-o", "test"
    assert_match("PASSED", shell_output("./test"))
  end
end
