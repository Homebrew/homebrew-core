class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https://github.com/google/nsync"
  url "https://github.com/google/nsync/archive/refs/tags/1.29.2.tar.gz"
  sha256 "1d63e967973733d2c97e841e3c05fac4d3fa299f01d14c86f2695594c7a4a2ec"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5646e78dfc90e6ea7a9575f5b51ccb91e142838e61170087a5ea89dd7076d1fd"
    sha256 cellar: :any,                 arm64_sonoma:  "fdcf50215956176ee21750ef95dea641a5464aa2c474e024d63c8032ddc99da1"
    sha256 cellar: :any,                 arm64_ventura: "163b4942545d21ed0042db6343b07b7ceb810010cd513a77d2f2d8060ace3b9a"
    sha256 cellar: :any,                 sonoma:        "03ffb1919593d89b4ce5e8bd58b540ebce76dedbfea579f06dfd3a1578af6120"
    sha256 cellar: :any,                 ventura:       "d8573c05ff6039c4074be9a4bb3119200ce4904e8f55b3747b50c2d9c08cb10f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7685d7883604fa8746a3e28034b2ac85632a807d575f0ae5e32173b0c96bc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "371b938f9cc2b55990b934c679a18967d749bf7a82783dce7ac49585fedb0379"
  end

  depends_on "cmake" => :build

  # PR ref: https://github.com/google/nsync/pull/24
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", "-DNSYNC_ENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index fcc3f41..9dbe677 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -125,7 +125,6 @@ elseif ("${CMAKE_SYSTEM_NAME}X" STREQUAL "DarwinX")
 		${NSYNC_OS_CPP_SRC}
 		"platform/c++11/src/nsync_semaphore_mutex.cc"
 		"platform/posix/src/clock_gettime.c"
-		"platform/posix/src/nsync_semaphore_mutex.c"
 	)
 elseif ("${CMAKE_SYSTEM_NAME}X" STREQUAL "LinuxX")
 	set (NSYNC_POSIX ON)
