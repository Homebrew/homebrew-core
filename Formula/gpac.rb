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
    sha256 "d685f84d817cfc62818f37d0eac9d743458973d7ec261a90fc9e8d1524f9f8bd" => :sierra
    sha256 "fa0031a62d043da3a90d3d63113bcc8206313cf0ce649d6e8ca5b5edfb23818c" => :el_capitan
    sha256 "d0ae48d8fd147077cf818df012921e7ae7e39a1768d61d9f82a9f361c1fff067" => :yosemite
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
