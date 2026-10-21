class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.14.tar.gz"
  sha256 "0f033fd6069387d2e489fbd2187e62f624764eb8c2758ee94e3e793e5150b5c5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "01017a613a2c1f9d66aaca6c9b3755bd62b7e7a98d5d8c7d188db7676690f638"
    sha256 cellar: :any, arm64_tahoe:       "15320a1a67389c01a3a8c39dcc57a2a0afae8d412e6a3b6897c643c39429e474"
    sha256 cellar: :any, arm64_sequoia:     "f824d313b5f2b806519dfd3cf23e8c115fb87346f1640e18fe8f1dabc1d7d514"
    sha256 cellar: :any, arm64_linux:       "476003fa37abd6c83c9b00eb2bcb2abe0c46bfde0898aa842e117e6669903642"
    sha256 cellar: :any, x86_64_linux:      "c06645ae3c34ca1fba1195f5bfa2455f46dd3cbe4b185afc608b7e74f6239f53"
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
