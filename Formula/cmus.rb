class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "db4d3a8fc7365aebb2d04c00fab660995e17fd33e1e858d227320f0132c5f750"
    sha256 arm64_big_sur:  "c5b09c75e7b2dba15327fd4d9e44558bc0e6349a38c812329930e5f699361f5b"
    sha256 monterey:       "33b6f93095d734ad3b94662251373c97ffd089da3487cb63bd8aa25c68feb326"
    sha256 big_sur:        "e45b48a6d19b61633897b73389c8c1648026543072735330018e85960f2b85cd"
    sha256 catalina:       "3b5595c657158e338d4ee9665afbc7ba4691e0eb228637eb42fb147b7cc33aee"
    sha256 x86_64_linux:   "7ee4112ba4f7a8c80b20a5edbee93bf01fae4c333bd24398023bc8d3c1e71f68"
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

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}",
                          "CONFIG_WAVPACK=n", "CONFIG_MPC=n"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
