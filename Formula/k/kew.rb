class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "b4a534501a4ce8813a8e9b06a87ce313af6cc53bb231c88c38c0d6b1a70358c5"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "8bc37b352f6c759d7dc775a13a4d3dfc76e78b2b441fc800a9ded432eea8acf0"
    sha256 arm64_tahoe:       "3c7c767e9eb3745043ad7208c649941447cc3d83301e0949b50ca6ced6277ec1"
    sha256 arm64_sequoia:     "f522728d32b4eea9b78dd6cae85a9c9c496147cd02cf3b33d37dea5fdcaa706e"
    sha256 arm64_linux:       "f1a29927ee06dc187e45be167842411344c513e091023d2152681d285a516a75"
    sha256 x86_64_linux:      "edd4564aefaf6c3fc1d56c116c34e716e33f34d34cd49e928770b05bfb1582ff"
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

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"

    (testpath/".config/kew").mkpath
    (testpath/".local/state").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    # `kew` puts the terminal in raw mode, so it needs to own a PTY to avoid `SIGTTOU`
    output = ""
    PTY.spawn(bin/"kew", "song") do |r, _w, _pid|
      r.winsize = [40, 120]
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "No Music found.", output
    assert_match "Please make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
