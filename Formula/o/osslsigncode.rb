class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.8.tar.gz"
  sha256 "d275d86bf0a8094e2c2ea451065299f965238be3cfaf3af6aff276302d759354"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8d5b69f29bac418152975bb0b288fa077823e7f2caaaea15a330f417276ef51"
    sha256 cellar: :any,                 arm64_ventura:  "e0f1712a32fd4eac4439b5f37aa0c828918d31865513e02d59e311d63462472d"
    sha256 cellar: :any,                 arm64_monterey: "11cf3fcd97f3a19d2eacdf3df2f91c435a4db55ef583b24aad028ba9ca58a4f6"
    sha256 cellar: :any,                 sonoma:         "b81dd3731b0f8c4518485c3cbaac40f83ec1e1612763699650366bf118325b94"
    sha256 cellar: :any,                 ventura:        "3a56ebcfdbdd9c1197991cd50b7828a337937daf12003131699b8fa06cc7a687"
    sha256 cellar: :any,                 monterey:       "141066fcb3a7f1337fa8acfb9c547ef1b4ce19078f996d664f52e71d84f1da3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b5b5279052424a356d3578dd592dfb4dcbb69e3b9be03a00740b6609c93ec1"
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
