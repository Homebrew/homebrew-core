class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.11.2/HandBrake-1.11.2-source.tar.bz2"
  sha256 "12b046350f2422dc28783ff94229aff4ba5fe5e683431e057355d36163b2593a"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9aab34cd5341ac8b56e1cc56143395979f0c2f8d860be8b0fa6999c12822711f"
    sha256 cellar: :any, arm64_sequoia: "84d5901e315408398b7389155a09ee58bd0714291b14001fb6c8d112db69e5de"
    sha256 cellar: :any, arm64_sonoma:  "300222b4c88313e367d0212d30001d6affa2cd2b5038f4dbd727d1858c89400e"
    sha256 cellar: :any, sonoma:        "c870c41a1c1e9f6e0d7111fecc13205f217e7301a7c1d40d6980ed7d533f45db"
    sha256 cellar: :any, arm64_linux:   "e62f807a79790358c2d11ee341e834189499a1dac6167e79c4ce10b66d54842f"
    sha256 cellar: :any, x86_64_linux:  "ef6e24d0f712f7c16b33d15c0a3e90774f7430d4250341275c72b9be2f0b46c7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
