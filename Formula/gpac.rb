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
    sha256 "5ab71b9b1701e246030da34e1bbd0d918a08406826ae8d3708a6f42b0c6c83aa" => :el_capitan
    sha256 "d27a205b21cdca024940fa59d151c8f108490a9e9c03db6df266e780f709b9ea" => :yosemite
    sha256 "0a7de80b027dcce38a6cadde54e9f1b89629633020de5a31405541d76ce2e00b" => :mavericks
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
  depends_on "openjpeg" => :optional

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
