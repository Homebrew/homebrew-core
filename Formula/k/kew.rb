class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "e2d3f508c56a03acadbb35a1659ab7c64f4fa4ef11fa0c9b5bcf880ef8bdc75e"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "d5526152a0701a0dc01fa34b084baf11f70e51fa3a58082ed766afdbb3fd1e39"
    sha256 arm64_tahoe:       "b9dc5769b1228540cc03b300c3f182808a1eb82c0a60592598a31b1c6538fcba"
    sha256 arm64_sequoia:     "5faa54a2c22f617fc625dad49ba673efa0a74c660daf58bf70503aaceb9ed9af"
    sha256 arm64_linux:       "0ca5d997d8f67cc47482d64772620d0f10d0aca01fc2cb96036d9ba57fd9ba0a"
    sha256 x86_64_linux:      "ffdcd450947e0486e27bd5f02ec3a9bfde5494d76ab09da6016150298353d536"
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
