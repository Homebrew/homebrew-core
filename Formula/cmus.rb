class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2a596cc72904648bf33093b295bcffe9c35b6218ef7d07786ad2810ffe417c0c"
    sha256 arm64_monterey: "4d9a04e3f219777e94ee43abbc36a08a308a4b038349b8421bb050fea197dcdc"
    sha256 arm64_big_sur:  "1da2b55446e9adbc6d72b4b22d91530ae4e8c07b8d5658b33622ec64313198a9"
    sha256 ventura:        "c155a740631ccf005e52301acfb1488e5c7c0686370d91f74c83a5df3b714e57"
    sha256 monterey:       "36f976d5db181233588ec371ad862f91725aed2d0797a53d96eb1dc99908a2b6"
    sha256 big_sur:        "1a2494a1a8ba3cdbe59c06617fd9fc1f1bb2f36b1126ce425e1b9d9f9fe34adf"
    sha256 catalina:       "965774a8170b4d6f194974736f4ac8d188a15da9bb75469a7ce915d4bbf93da0"
    sha256 x86_64_linux:   "1a95494ac6bbf9215e929bb5b51723eea1f5b08e15eeb66492544c2bf9df8778"
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
