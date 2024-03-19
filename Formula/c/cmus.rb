class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "ac3667bf52b88fe2cf1a91aee7444333eecbd1ee62ff2a1d35a696d286f7b555"
    sha256 arm64_ventura:  "7ecb43c204b78e089e1d5086667d098a35e764f234a89745c20bb59b13903e04"
    sha256 arm64_monterey: "8b7ad68e7c6559663e11a2e013f33967a97b084d2e8aa6b596bad4e78c951d03"
    sha256 sonoma:         "a82a68671e957b955646335ec35dcaeab4a7613d0c508dd112e0fb0d293bb89d"
    sha256 ventura:        "4beb90ae9a2dbb54575eb0bf8f7b4d6083a664d7f6d13f740281a40d449fed75"
    sha256 monterey:       "ed1c0cd1c55495510d62bb1b1132a28d0dc9ea80dc31224040c5ec8c502c8a42"
    sha256 x86_64_linux:   "2ba70e8f48e65519ffa546286baaf90e40b1ed573b2827456ae9145d4cd314f2"
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
