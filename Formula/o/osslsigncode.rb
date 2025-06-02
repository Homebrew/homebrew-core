class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.9.tar.gz"
  sha256 "3fe5488e442ad99f91410efeb7b029275366b5df9aa02371dcc89a8f8569ff55"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fe12f26f3bd487dc6663ffdc0d6091547e52b4c3f00f003eff28d932d23bddcf"
    sha256 cellar: :any,                 arm64_sonoma:   "917f9ac6b5ceaa7558b47929da67fa0aa3a7b3d6e4d2e7fb40f582c29bde91a2"
    sha256 cellar: :any,                 arm64_ventura:  "3024c29dd0838b5fa7c57edab3ed3e2373515e65dd211421d8384fe9088642cb"
    sha256 cellar: :any,                 arm64_monterey: "aa7c4c53ebf2aa83120b5883b0f8229e119fe1a4ac5bb97c1d3e9fcf141c1241"
    sha256 cellar: :any,                 sonoma:         "6278aff15a055a409edbc6aa4a69176befc7777325b3980afc58cd71737cf11a"
    sha256 cellar: :any,                 ventura:        "c09dfe8cb41d3af6327fb73695a7a5691c799b36f09331454b21a23e0e04ffbb"
    sha256 cellar: :any,                 monterey:       "a329dc07e46683d428cd6f8d9fe9b2bd6c02fc03b3f5c86dfbed1e5fdb244913"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "16aed1f489966abf85c8f7390840d8c2d487d1ee95026da0ca95085809b0f87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35630485849326c73bc6135118ccc391fdef8afd579371432207dd0aaec5f05"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "python"
  uses_from_macos "zlib"

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
