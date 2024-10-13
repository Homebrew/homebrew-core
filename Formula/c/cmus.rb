class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2bbdcd6bbbae301d734214eab791e3755baf4d16db24a44626961a489aa5e0f7"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "4d48fd259b20762d9c04a173efbf067aedfc63546c5e2d8b7cb60db0f0580e88"
    sha256 arm64_sonoma:   "db7240bb997b88208a1d1615eb318a2439c8c5c15bc3dc434f9056d6b0c563a0"
    sha256 arm64_ventura:  "e3c062549f70169a3ea7aba0785e8d1e77aaa5188e178efba38e6ce1edbfda52"
    sha256 arm64_monterey: "d83c3974dc01bc46172cf5603a3226a8b1363a1bd37fea7cac54154533254b0e"
    sha256 sonoma:         "d283fe9e60f2b50ec4335e8c40358b34905bb0cc455932e7d225b1d7ea30edbf"
    sha256 ventura:        "0faf7db511ed5efb310c9f0dbffea745bce21cf6d2525dfb78ae37f06c28213e"
    sha256 monterey:       "ca2869a665cec6bc773d848c5b682dd649f71410646bd6b1e88d956519ca6b62"
    sha256 x86_64_linux:   "c19deeb39b622a6acc22951199a64867b1754463506a62ad1f25e63d7bab3aad"
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "ncurses"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    args = [
      "prefix=#{prefix}",
      "mandir=#{man}",
      "CONFIG_WAVPACK=n",
      "CONFIG_MPC=n",
      "CONFIG_AO=y",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    plugins = shell_output("#{bin}/cmus --plugins")
    assert_match "ao", plugins
  end
end
