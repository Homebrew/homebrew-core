class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 1
    sha256 "2fba4aeeb76f1817f5847309eda9a05160d62b7ecd95d8e76a49bfea1b0a2828" => :mojave
    sha256 "686996921ceebcbb84f6d7090ce334e74da409230f87296d24312421072e67ed" => :high_sierra
    sha256 "7178a218283b5b65185456e09adc46501dc817304901516652546dcf5d56245e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
