class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1035.1.102.tar.gz"
  sha256 "1867fa0204c139f8073689b0d0785454b152b367762ff07ec9f316c97da1969b"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e996d7b3f938d78a596addcfb3e80252ecefc185bf9804aaab8487e305768517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3771dbe9bdb163d107a1a965fd940432f28fce425b9c6a73b69c98dc35dffea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "537e62b8d59a45af233d66c2294361e9d89ce31ac57fd2f9b8b4c191a6a80e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "926cf20954a1b9c7a8bafe7ce597256d2f516cd16e1a4a48db600feec95d91ea"
  end

  depends_on "llvm" => :build
  depends_on xcode: :build
  depends_on :macos

  conflicts_with "ocmtoc", because: "both install `mtoc` binaries"

  # Rearrange #include's to avoid macros defining function argument names in
  # LLVM's headers.
  patch :DATA

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "cctools.xcodeproj",
               "-scheme", "mtoc",
               "-configuration", "Release",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "CONFIGURATION_BUILD_DIR=build/Release",
               "HEADER_SEARCH_PATHS=#{Formula["llvm"].opt_include} $(HEADER_SEARCH_PATHS)"
    bin.install "build/Release/mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~C
      __attribute__((naked)) int start() {}
    C

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system ENV.cc, *args
    system bin/"mtoc", testpath/"test", testpath/"test.pe"
  end
end

__END__
diff --git a/libstuff/lto.c b/libstuff/lto.c
index ee9fc32..29b986c 100644
--- a/libstuff/lto.c
+++ b/libstuff/lto.c
@@ -6,8 +6,8 @@
 #include <sys/file.h>
 #include <dlfcn.h>
 #include <llvm-c/lto.h>
-#include "stuff/ofile.h"
 #include "stuff/llvm.h"
+#include "stuff/ofile.h"
 #include "stuff/lto.h"
 #include "stuff/allocate.h"
 #include "stuff/errors.h"
diff --git a/libstuff/reloc.c b/libstuff/reloc.c
index 296ffa2..33ad2b3 100644
--- a/libstuff/reloc.c
+++ b/libstuff/reloc.c
@@ -163,8 +163,6 @@ uint32_t r_type)
 	case CPU_TYPE_ARM64:
 	case CPU_TYPE_ARM64_32:
 	    return(FALSE);
-    case CPU_TYPE_RISCV32:
-        return(FALSE);
 	default:
 	    fatal("internal error: reloc_has_pair() called with unknown "
 		  "cputype (%u)", cputype);
