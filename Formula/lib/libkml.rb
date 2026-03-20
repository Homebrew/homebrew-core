class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://github.com/libkml/libkml"
  url "https://github.com/libkml/libkml/archive/refs/tags/1.3.0.tar.gz"
  sha256 "8892439e5570091965aaffe30b08631fdf7ca7f81f6495b4648f0950d7ea7963"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "3ebb7ff52e177135e9778b32bced8bed361a34ac4558ad2c4f822a40c41e21ae"
    sha256 cellar: :any,                 arm64_sequoia: "8daf78b5ae08619b23adcde8f6fd3b9c5d676bb904f912f4627a9e4b39f6752a"
    sha256 cellar: :any,                 arm64_sonoma:  "2923f263ce5799f8432706e17c9d96df8bbda6d2672c5ed1ec606ff9c38553cc"
    sha256 cellar: :any,                 sonoma:        "731845c227cc12dab82aca58a0ea4083c3508599ea685acc1e43509f9aaa703e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8fdd2de12de8e4c3586fe2248b6505d6e4e7eed8e21f5d3fdf0b029fe27910e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec60fee5a674c026878ff2341d4cc41391b5b61633a8488792e945b897c5709"
  end

  depends_on "boost" => [:build, :test]
  depends_on "cmake" => :build
  depends_on "googletest" => :test
  depends_on "pkgconf" => :test

  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "curl"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test", *flags
    assert_match "PASSED", shell_output("./test")
  end
end
