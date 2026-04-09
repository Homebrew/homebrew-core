class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "d00c4e00d989cb21b5de60b5bf21fe51e92c3f069c364cbcaec781ec8f38fc49"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "4fc345414fe92160c9f41e989a916dfa0264aba3735a2693912b5f8731b92a4b"
    sha256 arm64_sequoia: "09a4a0960121549ca718915ee7adc7c76d623b1185d61279413458dee5039be1"
    sha256 arm64_sonoma:  "582a0f8a5d2fe154ae92588c9e1d6208333f34ca46f1d7550f670ebab031c44e"
    sha256 sonoma:        "989390516013f40dadd4de3364bec028c1d739446d3e727f2d24f0ff7cb5577c"
    sha256 arm64_linux:   "03e018f7bdb1c61ce3bf8a64be2039395d1b305837d0cdfe290769970b33e70c"
    sha256 x86_64_linux:  "5a055a3d471c84dd7c0a02186e35be79b9851d606a42bb58d65a2f9bfcb434d8"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
