# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  url "https://github.com/gpac/gpac/archive/v0.6.1.tar.gz"
  sha256 "67d1ac8f8b3e74da0e4e38ea926dc15bca6e9941e8f366e3538abcf13c103c09"
  head "https://github.com/gpac/gpac.git"

  bottle do
    rebuild 1
    sha256 "30c49c6bfe3dc199eeef5929b43cb5e59eda7139a41ebb7ed62f7755e75ceebc" => :sierra
    sha256 "3c1ebe6435a0ca2daba610c89db1156e7296413942833184f6303bc72d38c98f" => :el_capitan
    sha256 "89488b011f9080924e2bc2e4c02c8aed633ab3bb7b1d7418b01e94c9e3136fc6" => :yosemite
    sha256 "831e4b7c778f7adb373d94b82a01f2aec35d02e1363f3389d67148481a7ecca4" => :mavericks
  end

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "a52dec" => :optional
  depends_on "jpeg" => :optional
  depends_on "faad2" => :optional
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mad" => :optional
  depends_on "sdl" => :optional
  depends_on "theora" => :optional
  depends_on "ffmpeg" => :optional

  def install
    args = ["--disable-wx",
            "--disable-pulseaudio",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]
    args << "--disable-x11" if build.without? "x11"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/MP4Box", "-add", test_fixtures("test.mp3"), "#{testpath}/out.mp4"
    File.exist? "#{testpath}/out.mp4"
  end
end
