class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.14.tar.gz"
  sha256 "0f033fd6069387d2e489fbd2187e62f624764eb8c2758ee94e3e793e5150b5c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1e8c161cd879c9d87f0a9218a028b44f7bf00c5e8a603363397a09a08c201827"
    sha256 cellar: :any, arm64_sequoia: "6950449c833a004f504efd4fcabf8b3d40457518d4b6054fa944c08ef010a218"
    sha256 cellar: :any, arm64_sonoma:  "7adf7b711352a655d0cc88b9ab0947b687f9b5adc54dcf51fbf62c32814411a6"
    sha256 cellar: :any, sonoma:        "027a4f1cf8bc305f6b540386911467314840d6ebcaba2c45024166776d04afa6"
    sha256 cellar: :any, arm64_linux:   "9a627497cce7d5436637905ccaa3c5f40b853215051b19147d395f65209cc34f"
    sha256 cellar: :any, x86_64_linux:  "4308aea9f197735e4bcfbe1d60e085b3de392b0fc9a906ea3ee36d753c550c58"
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
