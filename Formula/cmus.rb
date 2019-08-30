class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  revision 1
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 1
    sha256 "5597b87c7fcdceec789103df12ae89408e69f98668da522b7ee6a908e622c290" => :mojave
    sha256 "38f6dda244d82bc960b7e1c65e2e0316c2cde6cc61174bad763b7243e6f88ad8" => :high_sierra
    sha256 "42cab3ddb96e7b36b2b8cf67d2384adea5169e2955841c35166aece5afcd9329" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
