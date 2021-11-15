class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.9.1.tar.gz"
  sha256 "6fb799cae60db9324f03922bbb2e322107fd386ab429c0271996985294e2ef44"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "239fb9f0fa15ab6c051e28fa5d3b0804aba83436bd3a644e3a90ff83cf03e791"
    sha256 arm64_big_sur:  "ecccaccd592e7f937d93e0baf6c839d022bfd0142fb4c1ba1fb737bc5320cb8d"
    sha256 monterey:       "8cc6dae807e40748e229dc15f0037a637413d79f762f2f66b9283bf3fdc7cfa5"
    sha256 big_sur:        "39c4a5d3220e312651d65e83987f9deb6671a15229a268c050edbfe43ea259b2"
    sha256 catalina:       "b08d0e0bde83d0dd8bffdbb68e93c0a56675460ac5c7d89c0f734c8e9ef75cca"
    sha256 mojave:         "068793d374ba393662864da1a542a1bf036508bbd02ee9ac17249694ec93f5d2"
    sha256 x86_64_linux:   "2c089a54101cd2868df2d2312bdb0fe771a66492884baffc9ea1070854aeea1a"
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
