class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/releases/download/1.3.2/HandBrake-1.3.2-source.tar.bz2"
  sha256 "ec6feba97f426d545ec56cf1472eae5795d768bc1aec56c23bb76fc6b2ecf270"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b3cff9f9dd148a8f4a5b7d63fc35212b5384db92644693b0299b11d9cbc249d" => :catalina
    sha256 "b8335de02478b205184ef2c2fa57c84f2d53dc416f01b0d05ba68430a2305ddd" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on :xcode => ["10.3", :build]
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
