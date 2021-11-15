class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "6d1a9c1e9d1fa2f42419f47edc9a1231f6b5612f3d374c846e35052b1a2efd72"
    sha256 cellar: :any, arm64_big_sur:  "96b40ae847f00d3af538948aa95f68de0743385882222724b4e36598ba365d02"
    sha256 cellar: :any, monterey:       "520e0b5d47b1d734f519e5d763cd23f7b5863a360e7e315bc06dd3b4ba57a2ca"
    sha256 cellar: :any, big_sur:        "2417f672e669862eeb6a2529e3ace1bbaa78ee8f55b7ba555ed2d503d5f6a485"
    sha256 cellar: :any, catalina:       "cad8646a452226baa12e3f8de7a2b0edc8c7df8a33af36c2983e9105d60537fd"
    sha256 cellar: :any, mojave:         "6e8fededfc09e60dd3b3180360c257ede7cd8fcc3c2bfe83b68d82fcb2bfcab8"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Build against our googletest instead of the included one
  # Works around https://github.com/andrewprock/pokerstove/issues/74
  patch :DATA

  def install
    rm_rf "src/ext/googletest"
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
+find_package(gtest REQUIRED)
 include_directories(${GTEST_INCLUDE_DIRS})
 link_directories(${GTEST_LIBS_DIR})
 add_definitions("-fPIC")
