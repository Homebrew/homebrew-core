class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.6.tar.gz"
  sha256 "7f84bce7a6e9373e8c4df4fa90e723ca1d380cf303c80bbb3e02191179d0efc4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99237bd56e472b9c4ad4649a824b9b05372d4b32176c71ec9b276d33d67d6811"
    sha256 cellar: :any,                 arm64_monterey: "c4481087980ccc305862173445383bc74f9b4b3099754ffc25a2a3fc2e45af86"
    sha256 cellar: :any,                 arm64_big_sur:  "696c5b1e362edf6842fd4b9f4c55c527d08d8289e2673da982fe047afb848f1a"
    sha256 cellar: :any,                 ventura:        "a99e32840e4c7ce2413820d256bd7aae955ba5c5c65179bece3eb25815f2541a"
    sha256 cellar: :any,                 monterey:       "35789d3db3666991be42784f12c225f9826721d34c85bef2f346667d910e4565"
    sha256 cellar: :any,                 big_sur:        "b42275673763123bc3b77a92ec1bb744779bf694465b96dafcda95c41a1662ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2662456df8f22132f3c5be69ab300612b2b040518b15def9dea95599addf59f2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "python@3.11"
  end

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
