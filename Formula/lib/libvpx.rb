class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1020f184046187baa2985dbde38e0691f49c44088bca7a1842b0236c6081dc0a"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f9a11c2c10694acd896b66b09697b159cb82f5552837603cbb90366049562572"
    sha256 cellar: :any, arm64_tahoe:       "f98fa074f8eef7b2de3346fb83d4da15e7e6284fd13bf65210d855043f78f8c1"
    sha256 cellar: :any, arm64_sequoia:     "dd7924c0a05fa5f840f17ab9f5fac72d8672d75b2a7d44dbbf811274f70d17d6"
    sha256 cellar: :any, arm64_linux:       "82c10ba5a9b83d8afc77b2a9e7025ccfb9d75aee7332b85e489b374240347754"
    sha256 cellar: :any, x86_64_linux:      "85e403fcad2c6060c590a53b5cd17d8685ce155fd57385a4d17e70809e62e282"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # Add Golden Gate support. Remove patch when supported in a released version.
  patch :DATA

  deny_network_access!

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
index b37b998..e44b41a 100644
--- a/build/make/configure.sh
+++ b/build/make/configure.sh
@@ -832,7 +832,7 @@ process_common_toolchain() {
         tgt_isa=x86_64
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin1[0-9]\).*/\1/'`
         ;;
-      *darwin2[0-5]*)
+      *darwin2[0-7]*)
         tgt_isa=`uname -m`
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin2[0-9]\).*/\1/'`
         ;;
@@ -991,7 +991,7 @@ EOF
       add_cflags  "-mmacosx-version-min=10.15"
       add_ldflags "-mmacosx-version-min=10.15"
       ;;
-    *-darwin2[0-5]-*)
+    *-darwin2[0-7]-*)
       add_cflags  "-arch ${toolchain%%-*}"
       add_ldflags "-arch ${toolchain%%-*}"
       ;;
diff --git a/configure b/configure
index 9e9d80b..6722e99 100755
--- a/configure
+++ b/configure
@@ -105,6 +105,7 @@ all_platforms="${all_platforms} arm64-darwin22-gcc"
 all_platforms="${all_platforms} arm64-darwin23-gcc"
 all_platforms="${all_platforms} arm64-darwin24-gcc"
 all_platforms="${all_platforms} arm64-darwin25-gcc"
+all_platforms="${all_platforms} arm64-darwin27-gcc"
 all_platforms="${all_platforms} arm64-linux-gcc"
 all_platforms="${all_platforms} arm64-win64-gcc"
 all_platforms="${all_platforms} arm64-win64-vs15"
@@ -174,6 +175,7 @@ all_platforms="${all_platforms} x86_64-darwin22-gcc"
 all_platforms="${all_platforms} x86_64-darwin23-gcc"
 all_platforms="${all_platforms} x86_64-darwin24-gcc"
 all_platforms="${all_platforms} x86_64-darwin25-gcc"
+all_platforms="${all_platforms} x86_64-darwin27-gcc"
 all_platforms="${all_platforms} x86_64-iphonesimulator-gcc"
 all_platforms="${all_platforms} x86_64-linux-gcc"
 all_platforms="${all_platforms} x86_64-linux-icc"
