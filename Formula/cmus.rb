class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.9.0.tar.gz"
  sha256 "e7ea7f5ec52b991cf378a9caf19e479be16a165a5b26adca058de711e72ad2a0"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "652514673583bc8d219806bbd17f01a0a70df44b5285c8eba2f8c00fbaaf856e" => :big_sur
    sha256 "64ed09c00756ed773ec4e1e85f6d4f8d0e7b8bd26121f366da1640f5e1fbbddc" => :arm64_big_sur
    sha256 "00c4007a61fb12e59cb464115e31f27ff91fb9b2de57b11632beaa87b03141e7" => :catalina
    sha256 "151cdffad383c0d898709a998b4d8271a64a9405cb93e8bd41eada1503644ae3" => :mojave
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
