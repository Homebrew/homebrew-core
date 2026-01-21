class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.11.tar.gz"
  sha256 "dba4a483f596914b0edbddbb29b57c177752064674b50b2b09b87fb989d136a1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2dbaf84b2b3ec4a653a83de54f9ead5106a7ba83e69a60fbfb09499f3b2c3fcf"
    sha256 cellar: :any,                 arm64_sequoia: "bc252f798a8982c21836d7fb1e2f7b21bc460c3d5ea3c6d1f64307f5ae715daf"
    sha256 cellar: :any,                 arm64_sonoma:  "49301a2ab3eea53f0b19457c248200792f0eb6b84e7bcf4e6a1b620253a98873"
    sha256 cellar: :any,                 sonoma:        "1c220c2104e47d8ce163ee14e57570eab5935bed2681eb4d3bd15d9c75fc9679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2189127b411857edad9884526fee1eb57e67f2baef2cd7158fc4c52f26f3909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4c5e14fa4b0b08a32d75d06ce2012e39bcab281d0381037ae419f7ea5048ad"
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
