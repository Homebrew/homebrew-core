class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1021.4.tar.gz"
  sha256 "3d28444b2d33ae53a6ac0119846e98cfebdb5839a224a2436fe7537dcc0d79ae"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac0032654cba40741fb4cdd162651efca8c1dc3dc408038a2377de99a276c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0e915cd88cd910b0c5e232b010b94199ca75b0a8f08924fbb5d3848334a231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "510d19f1eb39b8a8f9f15ea6ebcfde4ffd1c75c9c60a04cf9d0100da94df0caf"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ada3c174f8a963144da540ed241d89cb10c4ab7c11f006105c337048ed389a"
    sha256 cellar: :any_skip_relocation, ventura:       "49a1662a7a1741e78834652a49c4629463d96b9eef3903b553cbf7a16e30228c"
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
