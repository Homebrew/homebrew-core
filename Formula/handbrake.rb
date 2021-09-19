class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.4.1/HandBrake-1.4.1-source.tar.bz2"
  sha256 "39a0aecac8f26de1d88ccaca0a39dfca4af52029a792a78f93a42057a54c18f6"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "037e8b1be2b8264f233aef92208ba264072a66cfdf26591dedd8a40ad44c5796"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d8f7a87b12e402d23142a3b4940170126a9e85ed6e218fe9af93aaf57f8eba2"
    sha256 cellar: :any_skip_relocation, catalina:      "3fe4097ce9a1f0ef6c22212eba9059ee3d181eb8a1875577994efff1d8be4d57"
    sha256 cellar: :any_skip_relocation, mojave:        "e4cedfb355baeed4c7b9ad6017db1be6f6cf2c666f4120a1a8eb95066b23a88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268c727839cac0f0d7044355ebc90ca8ee86ad1e44cc41bcf00eb766f37337f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: ["10.3", :build]
  depends_on "yasm" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jansson"
    depends_on "jpeg-turbo"
    depends_on "lame"
    depends_on "libass"
    depends_on "libvorbis"
    depends_on "libvpx"
    depends_on "numactl"
    depends_on "opus"
    depends_on "speex"
    depends_on "theora"
    depends_on "x264"
    depends_on "xz"
  end

  # Fix missing linker flag `-framework DiskArbitration`
  # Upstream PR: https://github.com/HandBrake/HandBrake/pull/3790
  patch :DATA

  def install
    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"

    ENV.append "CFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2" if OS.linux?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end

__END__
diff --git a/test/module.defs b/test/module.defs
index 011b17fb2..84a92fe5d 100644
--- a/test/module.defs
+++ b/test/module.defs
@@ -62,7 +62,7 @@ endif
 TEST.GCC.I += $(LIBHB.GCC.I)
 
 ifeq ($(HOST.system),darwin)
-    TEST.GCC.f += IOKit CoreServices CoreText CoreGraphics AudioToolbox VideoToolbox CoreMedia CoreVideo Foundation
+    TEST.GCC.f += IOKit CoreServices CoreText CoreGraphics AudioToolbox VideoToolbox CoreMedia CoreVideo Foundation DiskArbitration
     TEST.GCC.l += iconv
 else ifeq ($(HOST.system),linux)
     TEST.GCC.l += pthread dl m
