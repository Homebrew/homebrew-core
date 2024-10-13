class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.7.3/HandBrake-1.7.3-source.tar.bz2"
  sha256 "228681e9f361a69f1e813a112e9029d90fcf89e54172e7ff1863ce1995eae79a"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a1cd088e8531f4280b6e1504620e167de44498b357ed72d08ec14cadd54190dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "347873f90a91e53fa45ebbbc35e36616359c5579472b1b959c9385de469a324d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3b32cc386437c1ccb01c2ad1ec36d05534a50eba83f971d0575a0ff161bf852"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d21dca5e31bcf0fad0295ca4bc9d2e941e2dfcbeb291d0cd3f722fa401311718"
    sha256 cellar: :any_skip_relocation, sonoma:         "b338d003052d23a3199240f566dbe5bbd915eedab30098ce5f892952317eeffa"
    sha256 cellar: :any_skip_relocation, ventura:        "ccec04e70d6034016ca392aac8692cf8d95621f69d4efb3adadbd01edb45d476"
    sha256 cellar: :any_skip_relocation, monterey:       "aba4457f9045b7be4e966d8bedbf1db2d43c3d599d8a170de718c3f0b66f9ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e46b6be919867b917eb6db71151c02b601712d7e4403ea60aaa22d154d2db3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
