class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "f9a21c55f161cbf5f2d7106e1b815aa73fbc31c8cf1cd2d03a9fe07e6566286c"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "485d60ea535b3af8804b0db96bebd65e1c5e8aba2934bd15863cdcdce004316a"
    sha256 arm64_sequoia: "453feaf474d0c44efef0750cfa744414f94473e0d79de4d52f793c4a98117d40"
    sha256 arm64_sonoma:  "7f6c3104255b573507b5dacef976833830e8ff95c6bb446eabc4301926d51d22"
    sha256 arm64_linux:   "9b53b0159d816a12102fb10f6698dccfc04e12d58ea61b810d75326ce1cc5270"
    sha256 x86_64_linux:  "759595ac843e9643333b207eb3eb5516f0212c968fee1c1f0818ab3f0a669940"
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
