class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.09.22.00/proxygen-v2025.09.22.00.tar.gz"
  sha256 "f7e64ce78c605cfbe9b9ccbf00df41880d76bab319b87551d9deb46663c6f827"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "38ff29bbab49d2cdf8dea970d24ed0cb6ab84785c7d10f358b5f55e7439f6783"
    sha256                               arm64_sequoia: "5f41c8f6543d83f4abb070030f1b0f1d4205ab195b12bcb1f128b6f21af93eb7"
    sha256                               arm64_sonoma:  "8bc6ff330d2f0de6e94c2890ae6e25000d9b606df9c0fa92820aa44e692c5b51"
    sha256 cellar: :any,                 sonoma:        "e82b9d7500c00c5b7fd141e4b6f3a3d803a024a00c8eb0c3278aec2ea39c893f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e59f16c86fe9e4b25f4ebf11e071115e8e604be2add55d30c5d1a6a19a586a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a6f0b8fb001a4f87c154bb05d6035bdd38dd69f45fa01ea92aa552102a1495"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "c-ares"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix name of `liblibhttperf2`.
  # https://github.com/facebook/proxygen/pull/574
  patch do
    url "https://github.com/facebook/proxygen/commit/415ed3320f3d110f1d8c6846ca0582a4db7d225a.patch?full_index=1"
    sha256 "4ea28c2f87732526afad0f2b2b66be330ad3d4fc18d0f20eb5e1242b557a6fcf"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/proxygen/pull/570
  patch :DATA

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end

__END__
diff --git i/CMakeLists.txt w/CMakeLists.txt
index cc189df..9d61345 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -80,17 +80,21 @@ find_package(ZLIB REQUIRED)
 find_package(OpenSSL REQUIRED)
 find_package(Threads)
 find_package(c-ares REQUIRED)
-find_package(Boost 1.58 REQUIRED
-  COMPONENTS
+set(PROXYGEN_BOOST_COMPONENTS
     iostreams
     context
     filesystem
     program_options
     regex
-    system
     thread
     chrono
 )
+find_package(Boost 1.58 REQUIRED COMPONENTS ${PROXYGEN_BOOST_COMPONENTS})
+if (Boost_MAJOR_VERSION EQUAL 1 AND Boost_MINOR_VERSION LESS 69)
+    list(APPEND PROXYGEN_BOOST_COMPONENTS system)
+    find_package(Boost 1.58 REQUIRED COMPONENTS ${PROXYGEN_BOOST_COMPONENTS})
+endif()
+string(REPLACE ";" " " PROXYGEN_BOOST_COMPONENTS "${PROXYGEN_BOOST_COMPONENTS}")
 
 list(APPEND
     _PROXYGEN_COMMON_COMPILE_OPTIONS
diff --git i/cmake/proxygen-config.cmake.in w/cmake/proxygen-config.cmake.in
index 8899242..114aaf7 100644
--- i/cmake/proxygen-config.cmake.in
+++ w/cmake/proxygen-config.cmake.in
@@ -31,16 +31,7 @@ find_dependency(Fizz)
 find_dependency(ZLIB)
 find_dependency(OpenSSL)
 find_dependency(Threads)
-find_dependency(Boost 1.58 REQUIRED
-  COMPONENTS
-    iostreams
-    context
-    filesystem
-    program_options
-    regex
-    system
-    thread
-)
+find_dependency(Boost 1.58 REQUIRED COMPONENTS @PROXYGEN_BOOST_COMPONENTS@)
 find_dependency(c-ares REQUIRED)
 
 if(NOT TARGET proxygen::proxygen)
