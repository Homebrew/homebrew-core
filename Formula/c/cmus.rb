class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "4074540115754218e8bf925e834c5a69c2951eb19493ac063e5c627b4d753de5"
    sha256 arm64_sonoma:  "b314cf008fbeff9ad8a760b195fd401664ce032569a2956178d3e9446b22d24f"
    sha256 arm64_ventura: "abe20a3b224fbd98f698e7131208fd298a6aced10336f5f55a1156ecf1654e2e"
    sha256 sonoma:        "d9601411a0b749a5e379620985ac1f24d8ce566e744a7f24302964b1987b765e"
    sha256 ventura:       "9aac948ad9fab4826655c220590ac1f37fc0afb0d38c77bff081a6b0c104038e"
    sha256 arm64_linux:   "692eb54461a2b22de154ddbdd3507ca32ac2e4d249424cf246444bc66797d763"
    sha256 x86_64_linux:  "5ae15aefbec0e9633280d83a5d9eacbf5fb9682f18df4cf63a45584a75870f28"
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
