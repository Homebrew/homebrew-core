class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f64d0cd2170f0a0953e7e47f882db6e34fb1cdf5f36fa82cd5e07d28ba1b62fb"
    sha256 arm64_monterey: "707780a141ed9c245531081c8bfc40d5141813fffe2c93bc3ae04761824c9f08"
    sha256 arm64_big_sur:  "d1ffc2a28ff4bffeca29b95aca1cf4352d71c80274bf1c20e91c0310cddd9acc"
    sha256 ventura:        "e5fd6fb6ddddeb87c0d8bfc5fd5bccb616a6bda6cfb39e10b46d291a31a124af"
    sha256 monterey:       "96e863fc2effe0a810baeb9998b1fc56b44a4e9835d45b90285c51548ff198bd"
    sha256 big_sur:        "4ae91d46ab7aefb2458df0e17926f522c650709c105aa8d3a2ae91983c571328"
    sha256 x86_64_linux:   "879a206bb63d944f8aaeb8b5f854e31e808b95cfaca53c0dbe13bada8a6b2b90"
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
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
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
