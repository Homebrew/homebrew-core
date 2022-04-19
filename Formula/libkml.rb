class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://github.com/libkml/libkml"
  url "https://github.com/libkml/libkml/archive/refs/tags/1.3.0.tar.gz"
  sha256 "8892439e5570091965aaffe30b08631fdf7ca7f81f6495b4648f0950d7ea7963"

  bottle do
    sha256 cellar: :any, arm64_monterey: "93812e697f75c3ddebdb3f15b8b7e98773c49c69e929a244439c66076f81ff76"
    sha256 cellar: :any, arm64_big_sur:  "589b147706bc4aec04f96039cb2e61e80d85bcbedf0e919ebcca29fe09d81e26"
    sha256 cellar: :any, monterey:       "a217fb8977e5923462c00746cd607f510e76a9a20be9c53db554f5c72ffdfeef"
    sha256 cellar: :any, big_sur:        "a0694686c535fa33f6222e11dde9858881e6a5eaa12c6b11c5ef310a32635087"
    sha256 cellar: :any, catalina:       "2b73d6ea2eacd6e11229a0a9747444c28a455bb24943108b0351f689d17eb3d9"
    sha256 cellar: :any, mojave:         "c79c73e048728d0497b7f91c0e174bd97e27f65ff471e00324483a3557b6a13f"
    sha256 cellar: :any, high_sierra:    "31d567e2e0d87794adea3507cb34ace0483309de7ba5b32fc98bc1ca59a461c5"
    sha256 cellar: :any, sierra:         "860294d677de2f8a4c18e4d750d59aeafa2b38801b12eb76b5e951a23a8ec108"
    sha256 cellar: :any, el_capitan:     "57b9693cdf9a6abaeeea9648cd84a81d17ba0f056bd8d8e8442e68d97dbc7828"
    sha256 cellar: :any, yosemite:       "a3cdfca3ed0acbc93949683a8bb2862c36ec8bf06f20b9fe3752ac624667f455"
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
