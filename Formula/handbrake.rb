class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.5.1/HandBrake-1.5.1-source.tar.bz2"
  sha256 "3999fe06d5309c819799a73a968a8ec3840e7840c2b64af8f5cdb7fd8c9430f0"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a3146d36d5099624726932901910c41a155189f6c058a49c6292003b52244a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6c02d2641f222f77f5e6d4d1f37c03ee8490f23b65d54c22fae01f9071038b"
    sha256 cellar: :any_skip_relocation, monterey:       "a281ebf1ffb015c0f21d3697fdca14808da4ea1c38f90c2b83c85b92236308bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "da1aba2f8fb3eb2a3b9b54db36a0097426a342d4ce26da1e68a868f108ae5b5f"
    sha256 cellar: :any_skip_relocation, catalina:       "6866723e84ed84c71ff48bf20b54e368ec418c9c830f91e33907bee00a14425b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "935b180f5dec7910f6c7d54ba2066c0574d39c68a69d4a93353c0a513e5a3319"
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
