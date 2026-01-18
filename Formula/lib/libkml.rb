class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://github.com/libkml/libkml"
  url "https://github.com/libkml/libkml/archive/refs/tags/1.3.0.tar.gz"
  sha256 "8892439e5570091965aaffe30b08631fdf7ca7f81f6495b4648f0950d7ea7963"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "19536c853e34e55b5bdd36b1d566dbe546b25e8cb29374f490f8fa1bd185ebe4"
    sha256 cellar: :any,                 arm64_sequoia: "eb94aab1bf14416741d583115f1296611b1ce5fca7cef1748bf935cb28fdea02"
    sha256 cellar: :any,                 arm64_sonoma:  "1b1bcd07c0c72921902ad1ba84d8e184f4412b28b7553c3c293eedacab771604"
    sha256 cellar: :any,                 arm64_ventura: "e76761b18a288e50fdab372c0098846eebe2fd422beae5478837cbbed20e2212"
    sha256 cellar: :any,                 sonoma:        "085481f1cef637b7a0c20c9e1297fe9ad5ba68c5cfd0e4b5349cf038e17205af"
    sha256 cellar: :any,                 ventura:       "c26ab6d33b6f3d00bd73a1eb42aa558d72b5dfff9b31a97d6f5c57d5c6f6200c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd0dd2936b88b97b2ef2493dbcdda7103549067a4e5528fba3c3a4d1b3420d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee2cd309d2ded095b5def7e951816110d57c122c7192564e488a3cc4fddb360"
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
