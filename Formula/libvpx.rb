class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.12.0.tar.gz"
  sha256 "f1acc15d0fd0cb431f4bf6eac32d5e932e40ea1186fe78e074254d6d003957bb"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "741571520331ae15ead5b2f534d8c68b15ca8c9bbb60f405dbf82fde37a89887"
    sha256 cellar: :any,                 arm64_monterey: "95d64306db3eb31d8f8da747a067a6560acf9484f33bd8cca64b74835b8073ce"
    sha256 cellar: :any,                 arm64_big_sur:  "d571549026b2c719d055a9009ed7ce65060ff448da7a68e014f19d7543379a49"
    sha256 cellar: :any,                 ventura:        "50eceb4c3224910477c0344be333a2ecce4f749f3bdc61d66774f3238cb4ab74"
    sha256 cellar: :any,                 monterey:       "5c54abac298c4b6d2113d17343304ae9e0520f284a185f46e1baa03b10f60f9b"
    sha256 cellar: :any,                 big_sur:        "79e7d1a069bb6219b094fa9c51cd794e163623cda2b2fd8cbd5e41a77ace0eef"
    sha256 cellar: :any,                 catalina:       "9dcef4d29542d3506e3a2c458f6ae2eb36df48599cadf1a82fec972fcfacd935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763bca80c18bed0bea0704494e7370b919a498ac3521ff6f6f193a8902f78295"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  # Patch for macOS Ventura
  # Reported upstream: https://groups.google.com/a/webmproject.org/g/codec-devel/c/ofpypqweL5U
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
      --enable-vp9-highbitdepth
    ]

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
index 581042e38..fac9ea57b 100644
--- a/build/make/configure.sh
+++ b/build/make/configure.sh
@@ -791,7 +791,7 @@ process_common_toolchain() {
         tgt_isa=x86_64
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin1[0-9]\).*/\1/'`
         ;;
-      *darwin2[0-1]*)
+      *darwin2[0-9]*)
         tgt_isa=`uname -m`
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin2[0-9]\).*/\1/'`
         ;;
@@ -940,7 +940,7 @@ process_common_toolchain() {
       add_cflags  "-mmacosx-version-min=10.15"
       add_ldflags "-mmacosx-version-min=10.15"
       ;;
-    *-darwin2[0-1]-*)
+    *-darwin2[0-9]-*)
       add_cflags  "-arch ${toolchain%%-*}"
       add_ldflags "-arch ${toolchain%%-*}"
       ;;
diff --git a/configure b/configure
index 1b850b5e0..bf92e1ad1 100755
--- a/configure
+++ b/configure
@@ -101,6 +101,7 @@ all_platforms="${all_platforms} arm64-android-gcc"
 all_platforms="${all_platforms} arm64-darwin-gcc"
 all_platforms="${all_platforms} arm64-darwin20-gcc"
 all_platforms="${all_platforms} arm64-darwin21-gcc"
+all_platforms="${all_platforms} arm64-darwin22-gcc"
 all_platforms="${all_platforms} arm64-linux-gcc"
 all_platforms="${all_platforms} arm64-win64-gcc"
 all_platforms="${all_platforms} arm64-win64-vs15"
@@ -157,6 +158,7 @@ all_platforms="${all_platforms} x86_64-darwin18-gcc"
 all_platforms="${all_platforms} x86_64-darwin19-gcc"
 all_platforms="${all_platforms} x86_64-darwin20-gcc"
 all_platforms="${all_platforms} x86_64-darwin21-gcc"
+all_platforms="${all_platforms} x86_64-darwin22-gcc"
 all_platforms="${all_platforms} x86_64-iphonesimulator-gcc"
 all_platforms="${all_platforms} x86_64-linux-gcc"
 all_platforms="${all_platforms} x86_64-linux-icc"
