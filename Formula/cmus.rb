class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  revision 2
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "2242cd0ccda51a15e634040efbc2928df30602884c28aee5e5e22f2820f46f9d" => :mojave
    sha256 "7bd5e8f8d29efe7840caefc7f455a8e61bf02b467991a133a0b76cf89e8584fe" => :high_sierra
    sha256 "48171d7e6cd31ec1451a14c1c5275249f872c68c493910b39b1fa1d49eda04ad" => :sierra
    sha256 "deeed1d9ef93f0a8263b18a08239cab7a22983afe4278310f9944b79ab3df560" => :el_capitan
    sha256 "150534ed291aeb39a6c1a84a6efa6f1e4b518c0e3eae4e18efac9a5496e826af" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "flac"
  depends_on "libao"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "ffmpeg" => :optional
  depends_on "jack" => :optional
  depends_on "opusfile" => :optional

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
