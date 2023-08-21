class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "c676d903f551c4358b4fdc38f7b3152cdeb917b2a8390b0983f659fd6ba2d79d"
    sha256 arm64_monterey: "952c7e7175254572228a1e7a5c6b04be1a613cc4757cbf0d87f1e53263f745e7"
    sha256 arm64_big_sur:  "563768eef81faa0f544380e1cbe668da81038ad9252e80bb0cee275c8fcbacd8"
    sha256 ventura:        "65a22e527bfbd3dacd500e123452cf719e97011b95ede36e40b1e4e3496aca26"
    sha256 monterey:       "d38a5f8f62abd393a8afb60a1bceea1fd48d7668919959d107624fb3576c8c06"
    sha256 big_sur:        "98c14f791bef5c18758a47fe06da795cfa1f061665f7977959d7fd763cacd5ff"
    sha256 x86_64_linux:   "78f8cb1c5aa2a1cb0c06fbc53800eef904b4995712e399c9617bf1a82c4c224f"
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
