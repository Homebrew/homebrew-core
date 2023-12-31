class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.7.2/HandBrake-1.7.2-source.tar.bz2"
  sha256 "6a0fa23420483a2d74e58f0ad9944931d8f2e65bee63cf17333cbd9cb560ba93"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89839b1bd186ae1b34026da268befdbd8276694d0bd8462275c8161ac92af982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e97dae310a73424cfd2ae8e9231cbf09d33363134cefd92a8485d9006c984ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3693e80b9b776b54569d729bff2f1f9d41f830a254ea53a95b49ebfffb6dcc49"
    sha256 cellar: :any_skip_relocation, sonoma:         "759013d94337f1a9e269ddf65be11ae036164053ef14b0836d7fa557cb7be650"
    sha256 cellar: :any_skip_relocation, ventura:        "404ee5979562e630ebcea08f1caa698134bf69916157038c5efbb6c79e49f7d7"
    sha256 cellar: :any_skip_relocation, monterey:       "0ad1b90768d778fc41aa375b1d0b93444c82bf2f62080f7726477c64e051014b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6d076e4b17a96e5d0979e56a32be895b222bf74985a1d687d33e40303d60f8"
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
