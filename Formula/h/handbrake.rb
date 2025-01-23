class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.7.3/HandBrake-1.7.3-source.tar.bz2"
  sha256 "228681e9f361a69f1e813a112e9029d90fcf89e54172e7ff1863ce1995eae79a"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8a5a841bf2d70e6c069a296f35069715bc34a96d74c6942a865aafbda0d88c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af0147a74aea0cb4dc8e7090b2d4625ba2c359c3a13690e42315918c86e0a368"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f04c2bb371e0d477d6fab8f27c75f26ea965d50be376d7d7341e83ca158132d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d13a5b05c623a1a99503bff93f2d7721e0ddbc98de6b9a0b16b3c5858dbf3999"
    sha256 cellar: :any_skip_relocation, ventura:       "f3097de7b645328be204d1d6558678f8e5cc9d378a644863fb4f3077dad7ee5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85fa158e4b574b808fee42a03e76c3d870ac91cbb3cc1d4a2dbcb1e1133a0f9"
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

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
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
