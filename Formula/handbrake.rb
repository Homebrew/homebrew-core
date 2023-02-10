class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.6.1/HandBrake-1.6.1-source.tar.bz2"
  sha256 "94ccfe03db917a91650000c510f7fd53f844da19f19ad4b4be1b8f6bc31a8d4c"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4021520fa30313383ef0e4860a86c4786bdf69ea9ee2310be15ba4fb757d1b23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0ab524b340794ff669018f1174fa036b3638372d964ddb95bcaeccc5ca33a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1230916b027e5350d323269b52ec520beb243ad523dacfd95a5922a7b30337e9"
    sha256 cellar: :any_skip_relocation, ventura:        "b55cc93e2207f6e6081ff4d167c343bcb24836e959718a52e6a6672c160b30ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ce9c4d637366617959639ff48e921735b07c8ab327e3fc8d26a9199d9ee16a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9fcdd9de9d8657320a0858793f5d3b7eeb2f6deacb8e5126512206064d9ddd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02be5dc3f142e67f28663dcf6b7ed1053be0c119b991394f9b952610fcfbbc01"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
