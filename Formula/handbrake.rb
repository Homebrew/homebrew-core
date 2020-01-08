class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.3.1/HandBrake-1.3.1-source.tar.bz2"
  sha256 "c005de993af4123babbb60f7d12f6ff46fb7eea26ff0a3556034683901ce2c27"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65dbfb24905fbcc159e289f71a2027379770a919c6ae5e835686e3f40f9c16c6" => :catalina
    sha256 "aaf4e5946dfec10f52705b207ec4cc817223b472f8642a477b42446e7ee3dae9" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on :xcode => ["10.3", :build]
  depends_on "yasm" => :build

  def install
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
