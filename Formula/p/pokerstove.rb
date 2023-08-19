class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "354a7b64304cd6c7a0e04200a5eda12393737e7a4a96ce12470fe40ad80ff4ef"
    sha256 cellar: :any,                 arm64_monterey: "6565611ac56460fed1619e63506259fb19ffc5e619715d292d008c6286345bdb"
    sha256 cellar: :any,                 arm64_big_sur:  "612152599b7e4fbe9328967b9770e6bb8bb3cd45a8f07d03c30027633bffa52f"
    sha256 cellar: :any,                 ventura:        "77d153f1b85e2dc127cc78a7839e58ccfc52d53580665ecec3a56e7faa1e8d8c"
    sha256 cellar: :any,                 monterey:       "4d77e43f1ea5baa87e1b0e226885f86d939819a33ba4c84fd73c47c0e6a8c96d"
    sha256 cellar: :any,                 big_sur:        "8542c066554cf7309317c8fa3be1ccfe91e4056576f0b8f99fef568d5da04f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20618ea7f04f4bf92a7606f18df854a90268948e8f903c1484b4ea9154c7799c"
  end

  # failing to build in https://github.com/Homebrew/homebrew-core/pull/128510,
  # no response upstream since ~2021
  deprecate! date: "2023-05-10", because: :does_not_build

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost@1.76"

  # Build against our googletest instead of the included one
  # Works around https://github.com/andrewprock/pokerstove/issues/74
  patch :DATA

  def install
    rm_rf "src/ext/googletest"

    # Our `googletest` requires a newer C++ standard.
    inreplace "CMakeLists.txt", " -std=c++0x", ""
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "build/bin"
  end

  test do
    system bin/"peval_tests"
  end
end

__END__
--- pokerstove-1.0/CMakeLists.txt.ORIG	2021-02-14 19:26:14.000000000 +0000
+++ pokerstove-1.0/CMakeLists.txt	2021-02-14 19:26:29.000000000 +0000
@@ -14,8 +14,8 @@

 # Set up gtest. This must be set up before any subdirectories are
 # added which will use gtest.
-add_subdirectory(src/ext/googletest)
-find_library(gtest REQUIRED)
+#add_subdirectory(src/ext/googletest)
+find_package(GTest REQUIRED)
 include_directories(${GTEST_INCLUDE_DIRS})
 link_directories(${GTEST_LIBS_DIR})
 add_definitions("-fPIC")
