class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://github.com/libkml/libkml"
  url "https://github.com/libkml/libkml/archive/refs/tags/1.3.0.tar.gz"
  sha256 "8892439e5570091965aaffe30b08631fdf7ca7f81f6495b4648f0950d7ea7963"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "16858cec446e361bcf9e982681d9283e990e2ffca3ab0d85f54b23bd48557623"
    sha256 cellar: :any,                 arm64_sonoma:   "179af536831d605bf028ef8c8f343ae9463b60b2864bc473b4266659d994f4cf"
    sha256 cellar: :any,                 arm64_ventura:  "ee02b6adeccc3033cc99a2e8a45f8d21a4df7c487c0be1f05f623a7d3ac6ffa1"
    sha256 cellar: :any,                 arm64_monterey: "39b02cd2375b13cf321a80d04bdd90e07139bd99bd9e0f8b0ac816b96ec5920e"
    sha256 cellar: :any,                 arm64_big_sur:  "4c4e7310b060e79a58f209a910a56f7b9e5535305e81127afa0540ddb33c9d58"
    sha256 cellar: :any,                 sonoma:         "eb05bd2a83db1deae6c926aadd56c2128364c66d9f76c2c8ddafed1d65a0715d"
    sha256 cellar: :any,                 ventura:        "8c1aad6dd48f07f59db92056f984a4ea23de92a1f5103b39314e6995d7c7e43a"
    sha256 cellar: :any,                 monterey:       "8fea3543dfb5a38bcc28fdf049d30657ce12b20ab4435b41d0d4634856b28bd9"
    sha256 cellar: :any,                 big_sur:        "19bf29c790ba047803ce5ac8f33192d1bfd281458026870d74f18ee91c732203"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "18bf187fc45bb5fb71649813c9647d91ae0b27a4097dd8858dfc1c642ba18589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b827ac73d49a0fb2d3d0073ef374d6c9a54688698daf7600670594aa10ea6149"
  end

  depends_on "boost" => [:build, :test]
  depends_on "cmake" => :build
  depends_on "googletest" => :test
  depends_on "pkgconf" => :test

  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      libkml uses boost headers. To develop with libkml, install boost.
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    flags = shell_output("pkgconf --cflags --libs libkml gtest").chomp.split
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", *flags
    assert_match "PASSED", shell_output("./test")
  end
end
