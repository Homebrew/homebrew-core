class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.4.0/HandBrake-1.4.0-source.tar.bz2"
  sha256 "a871e5d95eaf616f27454d4d4eed3b4bea6be4ffd21f0dc16ed845132e0621b2"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5bb8e03dae1aa55d317425c029259de5b89b488f4a701d06baa2c3a1d1f7e98c"
    sha256 cellar: :any_skip_relocation, catalina: "ab4f6d98eb86afd4c71f74310867a8e919c827ea44c5aea52d56c9de33884ac8"
    sha256 cellar: :any_skip_relocation, mojave:   "7dd630c2fb5ea87ab59bd0e3c161b8091906484d7c286438cea86faaef2961cb"
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
  uses_from_macos "libxml2"

  on_linux do
    depends_on "jansson"
    depends_on "numactl"
    depends_on "opus"
  end

  def install
    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"

    on_linux do
      ENV.append "CFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2"
    end

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
