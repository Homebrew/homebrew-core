class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "e2d3f508c56a03acadbb35a1659ab7c64f4fa4ef11fa0c9b5bcf880ef8bdc75e"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "7f8c45f26dd1efb671a5e1d1b1004e1b2cb9a841d2e16516825762d54f188f47"
    sha256 arm64_tahoe:       "f2128b9f4fe5f757b117c3a4f041ee5beeacb4003db56a44dd000c09dab4a224"
    sha256 arm64_sequoia:     "2d39b19a3a113c8c98a707e3c69d8ec1fd4d472b39f44cf468f2a7e723c46415"
    sha256 arm64_linux:       "4b05c5dfe699b88a2e5320caa86d7fe2d66710235609e6522ec827c7d4d17c5c"
    sha256 x86_64_linux:      "f3de65b7eec153bc4cff06b5996468449968bd28b494f598d22c5b6b931ae8d3"
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
