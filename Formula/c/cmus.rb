class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "8b1739fd6bd6dce2b68c3f86b4587bd501e4d9559d978c1c1b9df5581c0a709b"
    sha256 arm64_sonoma:  "ce5bba497d1288d378ab93c8947b305928f7306bfdf46a938e5c43ad4e8f13ea"
    sha256 arm64_ventura: "fe14820def68e642197f8b7c6c0615edc9887b536083a69bd311aefe8c4c6c9b"
    sha256 sonoma:        "68cc3746e9c2f4f31357685474d76c565e7d28f3f4502b82427f0ee45eb02e5f"
    sha256 ventura:       "c18386b2327143c996a9b821118884bd511ed47cfc74742894659d1afc460faf"
    sha256 x86_64_linux:  "36afb0eb6672a1734b4c9cdfcb128b8c21ac925b69c854b6e7a8175bf21d2d20"
  end

  depends_on "pkgconf" => :build
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
