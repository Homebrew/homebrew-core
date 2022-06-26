class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.5.1/HandBrake-1.5.1-source.tar.bz2"
  sha256 "3999fe06d5309c819799a73a968a8ec3840e7840c2b64af8f5cdb7fd8c9430f0"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4046c86ec7f3bee73f9ca050dbc3338e61aa9a48e1d08e28a2b78e6c2d574506"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96ffdb5a88e0c04e281c11d6c16543950ccf4ad6355f621822ddc5c58f0558af"
    sha256 cellar: :any_skip_relocation, monterey:       "9ebce80e9b5b7149aa18b19eef3657a84a04bab20dafd521e3658fcb90a2a0df"
    sha256 cellar: :any_skip_relocation, big_sur:        "e13914d989020a6592a40c08dcd10fc4288db93abafa1b9fbba3b54628a3e78d"
    sha256 cellar: :any_skip_relocation, catalina:       "7d4c30c6b4be84e80b3f2333e44e951805e38a0b3b76c05dd0968f9f58b0a697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88d97354c37e76b8eb86afa2300a22b409ac0a41810d5e15039234974710760"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
