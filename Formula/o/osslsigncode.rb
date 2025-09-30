class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.10.tar.gz"
  sha256 "2a864e6127ee2350fb648070fa0d459c534ac6400ca0048886aeab7afb250f65"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f9f2a1dee5f24e89a1033fd5349047de93a95dbe2919108656d67d8da9e8bc8"
    sha256 cellar: :any,                 arm64_sequoia: "fd8ad32f52ef057d933f19cbbc7079921473b57b535614844f3960740c98581a"
    sha256 cellar: :any,                 arm64_sonoma:  "1541f1c9e846fcdf5498891da0059be1a1ba9146a6a07f66dc02ccdd4c34a423"
    sha256 cellar: :any,                 arm64_ventura: "acca14fc721a4925e89c4ef30296cb603df30c8293d1f780fa23ec441b4bbcf9"
    sha256 cellar: :any,                 sonoma:        "9fee24489fda92fc14e53f27973119ac57f4f05c7f91595cd675cb399e405131"
    sha256 cellar: :any,                 ventura:       "08ebace710cd6560aa21bcd1112b516fd8a1513c58c9b18cb4e5a5f005bd2f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c903cc86a4244f0c4bc172167b25646cc1b0342c27a0488aa9ab019aa030f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b07e1b0a71e98cac6810f3383533a908ec6349c7d2d54df23f21631ddeadfb"
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
