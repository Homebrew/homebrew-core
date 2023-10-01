class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.13.0.tar.gz"
  sha256 "cb2a393c9c1fae7aba76b950bb0ad393ba105409fe1a147ccd61b0aaa1501066"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c789c01604115f65bf5241052107ea8f4f1124a553c0bc0358e974533b2cf00"
    sha256 cellar: :any,                 arm64_ventura:  "868daf3511cf9fb086551f407caa54103c93e149dc31d4462a8b866370dc8682"
    sha256 cellar: :any,                 arm64_monterey: "cb9f419c82b0cef5ca968e0ba106898d4649d652f44d3fc8e7e9a2d62aa88134"
    sha256 cellar: :any,                 arm64_big_sur:  "16d6cb5c255eb5cfe8d2b6959f9adabb8f42b80787fdb1bdb2f75d6c6843e849"
    sha256 cellar: :any,                 sonoma:         "189a1122e5d82f2bee076032ae7b74c6dfa29f6337c18b5129504a89a72a24d0"
    sha256 cellar: :any,                 ventura:        "695248793be7b9764a1673cb69921b5d7e2f2200fe1f338d35286f82418762fb"
    sha256 cellar: :any,                 monterey:       "ee12fabeb869d1c7d42581b65aaafc10b535a8e598841fe07456ced8c0b52062"
    sha256 cellar: :any,                 big_sur:        "3f5b56aeac322d74c7b21434d8e287e868511c1cb2a2aefd3b05ca17daa5c14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8cf342f3173238c05c54294914cac333f939ca0329edb2ecca44c5ef7f05fd8"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  # Add Sonoma support (remove patch when supported in a `libvpx` version).
  patch :DATA

  def install
    # NOTE: `libvpx` will fail to build on new macOS versions before the
    # `configure` and `build/make/configure.sh` files are updated to support
    # the new target (e.g., `arm64-darwin23-gcc` for macOS 14). We [temporarily]
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
      --enable-shared
      --enable-vp9-highbitdepth
    ]
    args << "--target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc" if OS.mac?

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

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
index 4bf090f006f8fc86d45e533b33a4603efc0afac1..5d9b9622fc96c4e841d8c2833d149d9a79f5ab08 100644
--- a/build/make/configure.sh
+++ b/build/make/configure.sh
@@ -791,7 +791,7 @@ process_common_toolchain() {
         tgt_isa=x86_64
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin1[0-9]\).*/\1/'`
         ;;
-      *darwin2[0-2]*)
+      *darwin2[0-3]*)
         tgt_isa=`uname -m`
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin2[0-9]\).*/\1/'`
         ;;
@@ -940,7 +940,7 @@ process_common_toolchain() {
       add_cflags  "-mmacosx-version-min=10.15"
       add_ldflags "-mmacosx-version-min=10.15"
       ;;
-    *-darwin2[0-2]-*)
+    *-darwin2[0-3]-*)
       add_cflags  "-arch ${toolchain%%-*}"
       add_ldflags "-arch ${toolchain%%-*}"
       ;;
diff --git a/configure b/configure
index ae289f77b4a1994f3a1632573193124071f793b1..513556b2f81eefb2e69350188b6d6dcded1814ed 100755
--- a/configure
+++ b/configure
@@ -102,6 +102,7 @@ all_platforms="${all_platforms} arm64-darwin-gcc"
 all_platforms="${all_platforms} arm64-darwin20-gcc"
 all_platforms="${all_platforms} arm64-darwin21-gcc"
 all_platforms="${all_platforms} arm64-darwin22-gcc"
+all_platforms="${all_platforms} arm64-darwin23-gcc"
 all_platforms="${all_platforms} arm64-linux-gcc"
 all_platforms="${all_platforms} arm64-win64-gcc"
 all_platforms="${all_platforms} arm64-win64-vs15"
@@ -163,6 +164,7 @@ all_platforms="${all_platforms} x86_64-darwin19-gcc"
 all_platforms="${all_platforms} x86_64-darwin20-gcc"
 all_platforms="${all_platforms} x86_64-darwin21-gcc"
 all_platforms="${all_platforms} x86_64-darwin22-gcc"
+all_platforms="${all_platforms} x86_64-darwin23-gcc"
 all_platforms="${all_platforms} x86_64-iphonesimulator-gcc"
 all_platforms="${all_platforms} x86_64-linux-gcc"
 all_platforms="${all_platforms} x86_64-linux-icc"
