class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.13.tar.gz"
  sha256 "ee95638b8bec0c019ddf28cb14988645abbd180dcd017536338b7d0d5eaaea96"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5a60ba4972ee5f6bd4652c556fb92a7d93577ecd73ec263d779b409fb939182"
    sha256 cellar: :any,                 arm64_sequoia: "95dac23c9340dfb550aaf8a411cae92fa0f18dfffaef8e7db58531dcf54059c0"
    sha256 cellar: :any,                 arm64_sonoma:  "804c471846f4477628c4364fb8d851be6aef87425f831c782f6afa7dba34125f"
    sha256 cellar: :any,                 sonoma:        "f53ca1182dcce1fef94da4b4d3d2210ea23c14a0b5fb07690b35af901f0be035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e01e10074189e7999e27450a1b0c0b228a0d10be7a49a568c0ba2e4d323b890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177c66a589a8f306468f9e2de500a1295b91d3f3ef5be4aafac1dd4f22ff8abb"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
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
