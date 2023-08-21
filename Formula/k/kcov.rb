class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v42.tar.gz"
  sha256 "2c47d75397af248bc387f60cdd79180763e1f88f3dd71c94bb52478f8e74a1f8"
  license "GPL-2.0-or-later"
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "251550248b21e155d44d5677e4bc4a4ab58cc376c296ff4631ecaf29d8d3b81e"
    sha256 arm64_monterey: "42dc756dc1b009db595a122342809b542f92cf75e51a70679c70bd1e15e719be"
    sha256 arm64_big_sur:  "e162f14944c8588bef39cd000f8182d80706a05cd151d9179f9c7d4e0e0b6b2d"
    sha256 ventura:        "dd235dd9938c6efab9cf22a27a1479f978b4988f0a1b24309ae129717d937b46"
    sha256 monterey:       "f6eea5f30cfdfb9a99e9c15c6b2f8a496d64977accc78cd7237322e57619a1b7"
    sha256 big_sur:        "c88b2f16ebc426158e17f36a932ff63f5a3a42cc225d6c365b0ae73c0abe2275"
    sha256 x86_64_linux:   "2e6db1f8477d1bd9daa60af0f3e39634be0e2c42335f6a4a09a5e67d63287171"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "dwarfutils"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  # Fix build on Big Sur, remove with next release
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DSPECIFY_RPATH=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
__END__
diff --git a/src/engines/mach-engine.cc b/src/engines/mach-engine.cc
index ece8a1d..d9d475b 100644
--- a/src/engines/mach-engine.cc
+++ b/src/engines/mach-engine.cc
@@ -26,7 +26,12 @@
 #include <set>
 #include <signal.h>
 #include <spawn.h>
+#include <sys/errno.h>
+// clang-format off
+// sys/ptrace.h needs sys/types.h, so make sure clang-format doesn't change the order
+#include <sys/types.h>
 #include <sys/ptrace.h>
+// clang-format on
 #include <unistd.h>
 #include <unordered_map>
 #include <utils.hh>
