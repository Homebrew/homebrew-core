class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.16.tar.gz"
  sha256 "c8fce7cdb0f1643d98a6689cb3106fda8265f17014fd7912856c9473f9b141a7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2d9d1bcd279a494195c38dce1c3c2585cb8239f5da38a49cb2aa2fc35569e788"
    sha256 cellar: :any, arm64_tahoe:       "91c6620c876665a0b56a703181e8abf1bd71dc882eae6a03bb893162b34b78df"
    sha256 cellar: :any, arm64_sequoia:     "4f2440ddd206b5965ac9966a005049ea7fc26b720b8db344bd2a22fd892d77f8"
    sha256 cellar: :any, arm64_linux:       "f1054b19cc4adaad8a2810c782709440bba87065fee999466266bd4e357b2689"
    sha256 cellar: :any, x86_64_linux:      "afedd659d3f917faa012a5e4cab22cd732d3cbff29cc20921c8bd4a7beb62f3e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

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
