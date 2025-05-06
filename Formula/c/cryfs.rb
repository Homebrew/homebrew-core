class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/1.0.1/cryfs-1.0.1.tar.gz"
  sha256 "5383cd77c4ef606bb44568e9130c35a996f1075ee1bdfb68471ab8bc8229e711"
  license "LGPL-3.0-or-later"
  revision 2
  head "https://github.com/cryfs/cryfs.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "43c5238d9673debec44d49a779e516ff86a2f9737ad574714064ead388b0f717"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "acbcf4dbcbbf93a3f22a2380c961bd353d77986c2557e2a8a36ba5592bf2c941"
  end

  depends_on "cmake" => :build
  depends_on "curl" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "range-v3" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/cryfs/cryfs/issues/419
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "spdlog"

  # Update for changes in Boost.Process 1.88.0+.
  # PR ref: https://github.com/cryfs/cryfs/pull/494
  patch :DATA

  def install
    ENV.runtime_cpu_detection # for bundled cryptopp
    system "cmake", "-B", "build", "-S", ".", "-DCRYFS_UPDATE_CHECKS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)
    assert_match version.to_s, shell_output("#{bin}/cryfs --version")

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    expected_output = "fuse: device not found, try 'modprobe fuse' first"
    assert_match expected_output, pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end

__END__
diff --git a/src/cpp-utils/process/subprocess.cpp b/src/cpp-utils/process/subprocess.cpp
index 479bfe87..396ae09e 100644
--- a/src/cpp-utils/process/subprocess.cpp
+++ b/src/cpp-utils/process/subprocess.cpp
@@ -1,7 +1,18 @@
 #include "subprocess.h"
 #include <array>
 #include <boost/asio.hpp>
+#include <boost/version.hpp>
+#if BOOST_VERSION < 108800
 #include <boost/process.hpp>
+#else
+#define BOOST_PROCESS_VERSION 1
+#include <boost/process/v1/args.hpp>
+#include <boost/process/v1/async_pipe.hpp>
+#include <boost/process/v1/child.hpp>
+#include <boost/process/v1/exe.hpp>
+#include <boost/process/v1/io.hpp>
+#include <boost/process/v1/search_path.hpp>
+#endif
 #include <cerrno>
 #include <cstddef>
 #include <cstdio>
