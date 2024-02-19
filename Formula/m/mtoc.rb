class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-1009.3.tar.gz"
  sha256 "4b92468ca792244131c821b25cb7e8d133e7508178de1b3f4992ba8f08f19dca"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64ca5eeec93a13384e7a694319f7efd66031cc3e9a516b2f824dea49cc597f93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0954ac3e537307cee45ea244b7dcaf768f418e50c3f4dc9c95fa4ad7d59899ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82477e19e4a32c11f53643cb98592079b9b249c55154aab62bc44ebf23353c16"
    sha256 cellar: :any_skip_relocation, sonoma:         "c24baecad18e92b737f47d25211434e984d0a4eb01d4ffcd7da81c5c70c1a5ae"
    sha256 cellar: :any_skip_relocation, ventura:        "57dde70448e8595e9940d961fd78fdf7c0902d3cb0e88cfe39e5c60d431b90c1"
    sha256 cellar: :any_skip_relocation, monterey:       "d4dc48d23f9c700cbe7b56a5b7569c73b80085f817f9fa891fcb5cc7598f43bb"
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
    # error: DT_TOOLCHAIN_DIR cannot be used to evaluate HEADER_SEARCH_PATHS, use TOOLCHAIN_DIR instead
    inreplace "xcode/libstuff.xcconfig", "${DT_TOOLCHAIN_DIR}/usr/local/include",
                                         Formula["llvm"].opt_include

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
