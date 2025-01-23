class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "e935eded7d81631a538bfae703fd1e293aad1c7fd3407ba00440c95105d2011e"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b72c6376740d6c702c7bb1bca4292b9cb09b6aca7b16bcf01d5d2cccbaf7b7a"
    sha256 cellar: :any,                 arm64_sonoma:  "1a57c51283a0015aeab14dd14210f47beeb270321a85f5c5d3bddfc34c15b000"
    sha256 cellar: :any,                 arm64_ventura: "68b0b266de2faa807df3dcd3c85e0028c8c12c93d22874c0c2676575101a3362"
    sha256 cellar: :any,                 sonoma:        "823e82b27cf734c2a64525934a6909e3c07e09e0cb75a398afc2fbc66be0af78"
    sha256 cellar: :any,                 ventura:       "bfe84c4076b989468d359f0ebf2f46ad601da3383e6d50719accc374346b6853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a56173a7f792054fab125d92e8d5441329041b09bb26d1ee6e69efd3bac77df"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  # Add Sequoia support (remove patch when supported in a `libvpx` version).
  patch :DATA

  def install
    ENV.runtime_cpu_detection
    # NOTE: `libvpx` will fail to build on new macOS versions before the
    # `configure` and `build/make/configure.sh` files are updated to support
    # the new target (e.g., `arm64-darwin24-gcc` for macOS 15). We [temporarily]
    # patch these files to add the new target (until there is a new version).
    # If we don't want to create a patch each year, we can consider using
    # `--force-target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc`
    # to force the target instead.
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-runtime-cpu-detect
      --enable-shared
      --enable-vp9-highbitdepth
    ]
    args << "--target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc" if OS.mac?

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end

__END__
diff --git a/build/make/configure.sh b/build/make/configure.sh
index 8220d5c..cc5bf6c 100644
--- a/build/make/configure.sh
+++ b/build/make/configure.sh
@@ -832,7 +832,7 @@ process_common_toolchain() {
         tgt_isa=x86_64
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin1[0-9]\).*/\1/'`
         ;;
-      *darwin2[0-3]*)
+      *darwin2[0-4]*)
         tgt_isa=`uname -m`
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin2[0-9]\).*/\1/'`
         ;;
@@ -991,7 +991,7 @@ EOF
       add_cflags  "-mmacosx-version-min=10.15"
       add_ldflags "-mmacosx-version-min=10.15"
       ;;
-    *-darwin2[0-3]-*)
+    *-darwin2[0-4]-*)
       add_cflags  "-arch ${toolchain%%-*}"
       add_ldflags "-arch ${toolchain%%-*}"
       ;;
diff --git a/configure b/configure
index 97e7899..457bd6b 100755
--- a/configure
+++ b/configure
@@ -103,6 +103,7 @@ all_platforms="${all_platforms} arm64-darwin20-gcc"
 all_platforms="${all_platforms} arm64-darwin21-gcc"
 all_platforms="${all_platforms} arm64-darwin22-gcc"
 all_platforms="${all_platforms} arm64-darwin23-gcc"
+all_platforms="${all_platforms} arm64-darwin24-gcc"
 all_platforms="${all_platforms} arm64-linux-gcc"
 all_platforms="${all_platforms} arm64-win64-gcc"
 all_platforms="${all_platforms} arm64-win64-vs15"
@@ -167,6 +168,7 @@ all_platforms="${all_platforms} x86_64-darwin20-gcc"
 all_platforms="${all_platforms} x86_64-darwin21-gcc"
 all_platforms="${all_platforms} x86_64-darwin22-gcc"
 all_platforms="${all_platforms} x86_64-darwin23-gcc"
+all_platforms="${all_platforms} x86_64-darwin24-gcc"
 all_platforms="${all_platforms} x86_64-iphonesimulator-gcc"
 all_platforms="${all_platforms} x86_64-linux-gcc"
 all_platforms="${all_platforms} x86_64-linux-icc"
