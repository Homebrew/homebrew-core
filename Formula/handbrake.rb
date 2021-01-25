class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.3.3/HandBrake-1.3.3-source.tar.bz2"
  sha256 "218a37d95f48b5e7cf285363d3ab16c314d97627a7a710cab3758902ae877f85"
  license "GPL-2.0"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb8e03dae1aa55d317425c029259de5b89b488f4a701d06baa2c3a1d1f7e98c" => :big_sur
    sha256 "ab4f6d98eb86afd4c71f74310867a8e919c827ea44c5aea52d56c9de33884ac8" => :catalina
    sha256 "7dd630c2fb5ea87ab59bd0e3c161b8091906484d7c286438cea86faaef2961cb" => :mojave
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

  def install
    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"
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
