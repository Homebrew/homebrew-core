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
  url "https://github.com/gpac/gpac/archive/v0.7.1.tar.gz"
  sha256 "c7a18b9eea1264fee392e7222d16b180e0acdd6bb173ff6b8baadbf50b3b1d7f"
  head "https://github.com/gpac/gpac.git"

  bottle do
    sha256 "597da09d46c30397e67ca45d64c5783972db18e4f50a7a58c75c624d43e8e0d5" => :sierra
    sha256 "01308c943c8804c2ad077d860e9b58e47ad86beb85a019a85bd4de1fb659c710" => :el_capitan
    sha256 "2ddd05953278ade434e2bc7ba6e13c3a53767586d45816c7f6a1c7c2fa05df7b" => :yosemite
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
