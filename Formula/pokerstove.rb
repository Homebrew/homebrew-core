class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a777f6a3af03539d0c4f88b758cf177734f28642b98d82ce897c9a900be9bc8"
    sha256 cellar: :any,                 arm64_monterey: "f177335d352d77b1c3c0ad2d7046ee93906546f656b8c50a8e58aa24f2db8f1f"
    sha256 cellar: :any,                 arm64_big_sur:  "77574d7d911ebcb48df548d18f03922b55c4bc0e611f989f8f99dc0199d8484b"
    sha256 cellar: :any,                 ventura:        "678cfd3a639e608319a6b5081d866a0f333869e0da68cf8a2e0eb6ef87d2f40c"
    sha256 cellar: :any,                 monterey:       "a0f35cfe921cae6e212acb2102487cd11e616e91c44761e47ae8acca61f5957c"
    sha256 cellar: :any,                 big_sur:        "b3d8a72766c49448c9a13d3ae3a306c646d32ee983dd7d2db0e455e4313622dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533085f2aa512489b7e94729f5b8f46c476d7da591b55f768dd29f3c2ff93728"
  end

  # failing to build in https://github.com/Homebrew/homebrew-core/pull/128510,
  # no response upstream since ~2021
  deprecate! date: "2023-05-10", because: :does_not_build

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
