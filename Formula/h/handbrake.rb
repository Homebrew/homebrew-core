class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.10.2/HandBrake-1.10.2-source.tar.bz2"
  sha256 "c65e1cc4f8cfc36c24107b92c28d60e71ef185ec983e9a5841facffafea5f8db"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d3a39c056cd56eb9f56ab63407bf886088f190919668cbed3caf5e66ca4c032"
    sha256 cellar: :any,                 arm64_sequoia: "4cab7b397d57e95dcdbcc4d0afe366648190a569fb6a7312ab37799bb1a24ccb"
    sha256 cellar: :any,                 arm64_sonoma:  "fb419ece19e23536c4af6e464e73483e6ea057e67f0a6f859c5857a1ee2f75c7"
    sha256 cellar: :any,                 sonoma:        "fec30e2ef0b4f48f8ae12a825d4785d5e23a77ddadc4c77fc3d44aac8a93d3a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2284bd27ae585db94fb1674367517e8ae42eb2297857b66613e92eb059254a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07869bbe8ed2ae1c9cec894569b9d2f12486c7dff8130381a336d5771cbc733"
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

  on_macos do
    depends_on "libx11"
  end

  on_linux do
    depends_on "numactl"
    depends_on "zlib-ng-compat"
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
