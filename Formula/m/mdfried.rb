class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.8.tar.gz"
  sha256 "55b6b9aa22b9944f7f5f9634bbaef8d412fca091027ea0f1b08ede68d6335dec"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b5bcf103808b47687e5a01e64410bedce14289cd1cf763decd8cf6a3e6a4e27d"
    sha256 cellar: :any, arm64_tahoe:       "ccfbfb1c3672b95779cab7d4d49553df089e93ae27c47c8836ec226ebfcb6612"
    sha256 cellar: :any, arm64_sequoia:     "0ef65c20ffd6bdf17532a6373db7554d249f3624590d4e131616cfb96117cc22"
    sha256 cellar: :any, arm64_linux:       "213a6726b1705c2c6b624da83de9160919c2c46643d69150596931320d8a6f9c"
    sha256 cellar: :any, x86_64_linux:      "27cfad89c58dbc115be62c3bfd390328285187457d4ee2ef0ea9823b9af170c3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
