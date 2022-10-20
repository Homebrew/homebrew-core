class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "505ed83a6d1a32c5730eb7543e26caf0fc6e1cf2be9ac258f65287aaa9f0f0da"
    sha256 cellar: :any,                 arm64_big_sur:  "421bf090b59bb08de95e1f288f63aef85f3b00ee809691e6053b473dc189f630"
    sha256 cellar: :any,                 monterey:       "63c43267ec9ba346ded19cd765cb9b8fb6ac403d9d6a8c581fc6183a557179d3"
    sha256 cellar: :any,                 big_sur:        "354ad4f655fdbda20dd9ae0a6b23db9323cd1fd56d9b26292af8c57f8d2a9517"
    sha256 cellar: :any,                 catalina:       "c0d554d15641d04605d0c4fadd25afced0a4d4dbf74f2304f5d9e95190ffaaeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a3781f7d90682ae4f17b28ed6569ed57f1a3922d1efff3e75be9e6d0c6620a"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Build against our googletest instead of the included one
  # Works around https://github.com/andrewprock/pokerstove/issues/74
  patch :DATA

  def install
    rm_rf "src/ext/googletest"

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "src/lib/pokerstove/util/CMakeLists.txt",
                "gtest_main", "gtest_main pthread"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install Dir["bin/*"]
    end
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
