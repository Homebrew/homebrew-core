class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1010.6.tar.gz"
  sha256 "19dadff2a4d23db17a50605a1fe7ad2d4b308fdf142d4dec0c94316e7678dc3f"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a2e0cff36af9f659bcbb7165d1f180ef4408a0423af23b85c2f4312db8806f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb9f6732da0297987d62d37c6f662a9679527fa7a3c80f45f7edf6c0ebda7b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18bf5ccdeeea52a6e5c0172e623b62142c8e52fca847720bbb88fa441c4f31c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c5fb90c5c4195d212cec400aaf85e629f367d42f5924624bc01b20d4850b0a"
    sha256 cellar: :any_skip_relocation, ventura:        "9d99cef4e8e1bca0c12e33b574f18700f6492929ec302bbbcfc357ed0da27f67"
    sha256 cellar: :any_skip_relocation, monterey:       "8a66535f89e326120675f1e809ca4c6e53bcc5b26c6616c169d598b1affeda8c"
  end

  depends_on "llvm" => :build
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
    (testpath/"test.c").write <<~EOS
      __attribute__((naked)) int start() {}
    EOS

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system ENV.cc, *args
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
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
