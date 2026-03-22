class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.11.0/HandBrake-1.11.0-source.tar.bz2"
  sha256 "c5de77365b083f519c76b9edcc0685d8bda9ce04fc0ad59c3c38145355ef1b17"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62bc75a4742e0a57cfbbca7ea877bc1ea9da623e5855cc99fc0de31bd77a9215"
    sha256 cellar: :any,                 arm64_sequoia: "c9c95e193870201045a569c46c836aa543855d36d5ec25b421dbde384dfddc0f"
    sha256 cellar: :any,                 arm64_sonoma:  "611ae94bc08bbb89dd0e16f26475f40026e395a378cc71818e496e7f7a3964b0"
    sha256 cellar: :any,                 sonoma:        "404c788c5c74eeab3018885f33c1172d39bf2f359323945d9682bf5ca87c6879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "537b85f124f68ba9341c743f899d7b8f63101fb228065e225d14d7c05757f9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef64a622c0c98095b5db1582dc76ca6e54b01e19cf378fc2773380db1d4e63fa"
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
