class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "41ac6ce47d99a7762dd224b5b92f156c18b88d9907626b648b80df95e45d9ccc" => :mojave
    sha256 "8a8846a36f4eac433548d0351ef52fe3b1b8dfb072d03dc51cd81dd61f5991d9" => :high_sierra
    sha256 "47f63ee376d18f45dbaa047960c6769669b852167bcc0bea82f7de93336ce474" => :sierra
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
