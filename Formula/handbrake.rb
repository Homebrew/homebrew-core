class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.4.2/HandBrake-1.4.2-source.tar.bz2"
  sha256 "8b8e81b7dc2e3180f4e94e8c7f5337d2953f69f0d983ccce48096e29ed6dfb61"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d413052e01020c916cd1e9bf244256b5b1248f4f8e26fcfbde7dc02dd5a380"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e917c720059f925166013d3d0e2582e31699ebbdbbc08fca18dfdffabfd7c8b3"
    sha256 cellar: :any_skip_relocation, monterey:       "6e422e359c35c8529ff47af9bd60d3755ad7466dcf693d619e4ef98a3cd88656"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ca402d6d31e8e0a8cd95d145c418081f7d463fb2038c8b699c9a14b5b97dcea"
    sha256 cellar: :any_skip_relocation, catalina:       "6264a00f9a6de388ea623778ce204d88fbe2638984685685f5081afc7847c7b4"
    sha256 cellar: :any_skip_relocation, mojave:         "fb8a0e4d9a85ceafe357b05148e2f457fc27c209772f09c6625ecc4a710ff645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3acefc4aab0ea90d6677cd7178e2753eddb28ae520e76e12544f7887234c81a7"
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
