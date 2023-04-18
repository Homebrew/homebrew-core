class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.6.1/HandBrake-1.6.1-source.tar.bz2"
  sha256 "94ccfe03db917a91650000c510f7fd53f844da19f19ad4b4be1b8f6bc31a8d4c"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e5f63cdb95b25c5413fed7ce3915a089d44ed6c5996be9cd84c55b642231e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37bd7be3f905a7306d009e810ffab50233274bdb638a75f4ffbf50ebeeae737d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e06e53d7c973f66d12f8fb508b5cae5a5fb04f56c28b2d9bfae2ea99ec9ad4fa"
    sha256 cellar: :any_skip_relocation, ventura:        "bc015419768b2af7d4878a02f23f8c4331763cdf3cc1dc09a38deba82f7527e3"
    sha256 cellar: :any_skip_relocation, monterey:       "b53be55508115ba147ddab5db7076a292de59628240e898dc89690f0ddef6f5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "18e10c745419996f3e9f11ab13a9b69dc66129157c96e9085b7f842987eecc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b634013a3dbf5f5022d3a11a51df9de1b7f6f2af61deefd3fd5ea9b2964e4d"
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
