class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.4.2/HandBrake-1.4.2-source.tar.bz2"
  sha256 "8b8e81b7dc2e3180f4e94e8c7f5337d2953f69f0d983ccce48096e29ed6dfb61"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce915dd92e8ecea860c57f930fe059fbebb2f4282a64c68c77988d6e4e3ba090"
    sha256 cellar: :any_skip_relocation, big_sur:       "bdaf789e29ad765f12f4ee1d6173bc7c4254019c979646f87b5054be3dd9c785"
    sha256 cellar: :any_skip_relocation, catalina:      "405a3c3c9d3511ddcf31b93c800e6db7fe6c1dbfacc68b98891ef846dec1d390"
    sha256 cellar: :any_skip_relocation, mojave:        "cd6a2f04d56322bd3f51ca0b64f54e51a98d3709d9c0a62e42c6475658bcbe60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "036238b99cddfee4e7553d14a82aadf6e14293b8903126b620d88f0dc0d7a7b2"
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
