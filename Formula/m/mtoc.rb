class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1024.3.tar.gz"
  sha256 "ffe47144929605307826d9cc5697369e18c83f681860e3c397b6c11279e03318"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee82cf8117b696fd2cbbf0994706e9efa73aa2403adc15a5fbc50fa0be9b8e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c766c433b8ae315ef4a2386327c5ae674b5a360faaa29f0449677ae32f74e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9605d52ea43f7661e05cf626ebfe6a68e57a5aa2985d05ac0c64f54c07ed55b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b41ec3a03f405eb6d60abec7c08f3e97e6c19de4f291050281f2ac9df680b53d"
    sha256 cellar: :any_skip_relocation, ventura:       "5e882dbfadd1b1c6a167e4930f6c5aeda8b8f25c110dd7c679167ba0abc0e971"
  end

  depends_on "llvm" => :build
  depends_on xcode: :build
  depends_on :macos

  conflicts_with "ocmtoc", because: "both install `mtoc` binaries"

  patch do
    url "https://raw.githubusercontent.com/acidanthera/ocbuild/d3e57820ce85bc2ed4ce20cc25819e763c17c114/patches/mtoc-permissions.patch"
    sha256 "0d20ee119368e30913936dfee51055a1055b96dde835f277099cb7bcd4a34daf"
  end

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
    system bin/"mtoc", "#{testpath}/test", "#{testpath}/test.pe"
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
