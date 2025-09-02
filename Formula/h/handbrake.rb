class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.10.1/HandBrake-1.10.1-source.tar.bz2"
  sha256 "eafa87d64b99c457240675f6b89a7f6aa3c1eb56352ec057a0a0949ba449fe8e"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67eb5316c06cb84fd071d75fa4f665dd07ef41e7a0b3509602745c78a58e022e"
    sha256 cellar: :any,                 arm64_sonoma:  "265c0ca237009e86b72057cb9599ff3ec54988250e8caff4b6025227e83d90de"
    sha256 cellar: :any,                 arm64_ventura: "be24ddcfef2bbdc96c7a9ab26071d1403c6da67aaaf73c806b5a03d53991c77f"
    sha256 cellar: :any,                 sonoma:        "64101e9570718dea13212bf40c4176734a8cd0eca83f8c7002650916c0106a7a"
    sha256 cellar: :any,                 ventura:       "0ebcd911a6f725903074d62d16f64bfff297e36dd5e8f70eed5c400d835a58e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c003039ece52d1cc6baee52319dbf47a7bc2f2c9559ac2b7d728c14035861db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0718bbec4e5c290f967fc10e7fb6c81dfcdc64800d5d9facf6520a414cc549c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "yasm" => :build

  depends_on "dav1d"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "jansson"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libdvdnav"
  depends_on "libdvdread"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "speex"
  depends_on "svt-av1"
  depends_on "theora"
  depends_on "x264"
  depends_on "xz"
  depends_on "zimg"

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "numactl"
  end

  def install
    # Several vendored dependencies, including x265 and svt-av1, attempt detection
    # of supported CPU features in the compiler via -march flags.
    ENV.runtime_cpu_detection

    # Remove bundled dependencies and use homebrew formulae
    # ffmpeg : error: use of undeclared identifier 'AV_FRAME_DATA_DOVI_RPU_BUFFER_T35'
    # x265 : error: no member named 'ambientIlluminance' in 'struct x265_param'
    libs = %w[
      freetype fribidi harfbuzz jansson lame
      libass libbluray libdav1d libdvdread libdvdnav
      libjpeg-turbo libogg libopus libspeex libtheora
      libvorbis libvpx svt-av1 x264 zimg
    ]
    inreplace "make/include/main.defs" do |s|
      libs.each { |dep| s.gsub! "contrib/#{dep}", "" }
    end

    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"

    if OS.linux? && Hardware::CPU.arm?
      # Disable SVE2 for ARM builds, as it causes issues with the x265 module.
      inreplace ["contrib/x265_10bit/module.defs", "contrib/x265_12bit/module.defs", "contrib/x265_8bit/module.defs"],
                "-DENABLE_CLI=OFF",
                "-DENABLE_CLI=OFF -DENABLE_SVE2=OFF"

      # Fix AArch64 assembly for pixel-util.S
      (buildpath/"contrib/x265/A09-aarch64-fix.patch").write <<~PATCH
        diff --git a/source/common/aarch64/pixel-util.S b/source/common/aarch64/pixel-util.S
        index e2b31e4..1bcaf4a 100644
        --- a/source/common/aarch64/pixel-util.S
        +++ b/source/common/aarch64/pixel-util.S
        @@ -860,7 +860,7 @@ function PFX(scanPosLast_neon)
             lsl             w13, w13, w6
             lsl             w15, w15, w6
             extr            w14, w14, w13, #31
        -    bfc             w15, #31, #1
        +    bfm             w15, wzr, #31, #31
             cbnz            w15, .Loop_spl_1
         .Lpext_end:
             strh            w14, [x2], #2
      PATCH
    end

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
