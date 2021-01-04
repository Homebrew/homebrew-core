class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  license "GPL-2.0"
  revision 6
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "9125314022209f8a28ec6b9b0f1298c990b3ef4a7b5d3970c1466fd95ee3023b" => :big_sur
    sha256 "84d0cbe96063e77665e24193b223a8cb1117c9b180009990af6ff9891bc7013c" => :arm64_big_sur
    sha256 "9e9a3aff98eab65a1e1f5b212dab68af90affb189cf80b22a526037a50c5da43" => :catalina
    sha256 "cecf891598d7edd93be3f429ed5ef05a2962a23fb0b53e54c413373b72ddeb6b" => :mojave
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
    system "./configure", "prefix=#{prefix}", "mandir=#{man}",
                          "CONFIG_WAVPACK=n", "CONFIG_MPC=n"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
