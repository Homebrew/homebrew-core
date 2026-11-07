class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.15.tar.gz"
  sha256 "799e708fca0bcbd2e10ff61e9d7b8f04e1d2a558e118717b459206ede17b0046"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4cfbedffb917025ea1dcc5aecc8d3fd25e1e8a32bc580f3b82284343ddb14b63"
    sha256 cellar: :any, arm64_tahoe:       "036ef921d91718e80760d34494c6b1263c1685121d85d17ebd46c00f06d4c228"
    sha256 cellar: :any, arm64_sequoia:     "60a8ab9d41b2579e685442c8d22f6cbde6c4a2fce6e3f07dfb2387eb0e4f2237"
    sha256 cellar: :any, arm64_linux:       "48310ddfdf8c93fae163eb2c35ce536f304cdf43a79c0bd995da0663542af1ec"
    sha256 cellar: :any, x86_64_linux:      "5ff48de5b0ea0c4551b9b1b76b42fa344c0de15d7a5ce3f32f911a97c46e07e6"
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
