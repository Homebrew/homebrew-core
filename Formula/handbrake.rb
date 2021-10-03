class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.4.2/HandBrake-1.4.2-source.tar.bz2"
  sha256 "8b8e81b7dc2e3180f4e94e8c7f5337d2953f69f0d983ccce48096e29ed6dfb61"
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
