class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.7.tar.gz"
  sha256 "00fc2b43395d89a2d07ebbd4981e7a9dbc676c7115d122a1385441c0294239b8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee253906f690082fb0f95925c7ca20973748f3c7f622b181c284b1bf2221756d"
    sha256 cellar: :any,                 arm64_ventura:  "1f6ab0d22e1025c6b5d66c8978e338fe3f85f5b924709b28d7625d3861951e32"
    sha256 cellar: :any,                 arm64_monterey: "d3fb5dfb502c3c3fd7a1a8a55a0105852c5eb68b995da2fce81009827f953042"
    sha256 cellar: :any,                 arm64_big_sur:  "46b8c4c787717d1847fee881670449f95a2c5a34701506b7cfe8c59d858050ad"
    sha256 cellar: :any,                 sonoma:         "7f49058612fcc742b1e456e5452a56d4dd097d6a675b6fa8ec4cdcc569b2b351"
    sha256 cellar: :any,                 ventura:        "5011f0d203e816aab853cabc73d16e5dab6f4c1e1673f79c5fbaae83a7c7fe7a"
    sha256 cellar: :any,                 monterey:       "b4ebe200ae4b762b5824a4855d95e2a23ac13c93d3a92cd973de6759e6df9bb3"
    sha256 cellar: :any,                 big_sur:        "778fdb11adce389448e9d034fd9b5b0062671eb71ae40e5f297297bf6c11c7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba9e75264cb30857cbb73ab8f0863a5a039c9005a9b296732d78b4ab09a7ff7e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "python"

  # Fix permission issue when installing bash completionn
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "osslsigncode.bash" => "osslsigncode"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2ffeb4e..7e2bc01 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -33,7 +33,6 @@ include(FindCURL)

 # load CMake project modules
 set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
-include(SetBashCompletion)
 include(FindHeaders)

 # define the target
