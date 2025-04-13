class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.9.2/HandBrake-1.9.2-source.tar.bz2"
  sha256 "f56696b9863a6c926c0eabdcb980cece9aa222c650278d455ac6873d3220ce49"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e522355fdd80a18975dff369e4f84f114db24bdd998c9aabf0412e37870d3c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bf626472451af5250d1ad1bda30d045fd8524c8ead478ba10c6617137513ea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0963b2fe7afb36039db49f6d70bfb956d762e2f45dc8f8f75f6b788f130e27e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d51673f0d57cf519ca07cef60fd47d3102352a7eb15c9b74cd5528cfc34dce"
    sha256 cellar: :any_skip_relocation, ventura:       "e4566e9531e9b4ef8e1424d2b64881a42849fa998c4f41723e7901ac69fa869c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5897d3846d9bc98ae0ca7f17f818aa471dc3c77c0fee7cff49c9870e27cfd60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d369bff496ed3e599714b882be69de1d774ec7f4c36863de22e230ea1739cca7"
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
    # Several vendored dependencies, including x265 and svt-av1, attempt detection
    # of supported CPU features in the compiler via -march flags.
    ENV.runtime_cpu_detection

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
