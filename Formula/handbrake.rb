class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.6.1/HandBrake-1.6.1-source.tar.bz2"
  sha256 "94ccfe03db917a91650000c510f7fd53f844da19f19ad4b4be1b8f6bc31a8d4c"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8037827d84b9216fcd72a6035d2da154d27e2750052428f10d8fc9f9f2ffa355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a83a7108a84b2316fc334819d80e1277c96b7f1f421c650cf473ae113b5c9b2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "851f45d030bcc6b6493d9fe3b2c4a25e5dfa7babf0b091c02bd9190389fe66bc"
    sha256 cellar: :any_skip_relocation, ventura:        "7e716b18c29d347c42ce5970dc3901a4b637931f3e574ef54c677fc35de804b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e2cc5bc6858a8cce319d79674ce9a778352a91fa3bb61d99b3bf2de14fc3d2ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f02b15ff874f73babe3df810886bf2729bf8ec01472d098a728b8e652b78d74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d6a828d69f3ad69b29d0f6f91fd517ccdae591c36531803e0639c65772da1f"
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
