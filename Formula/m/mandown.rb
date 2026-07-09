class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/refs/tags/v1.0.5.2.tar.gz"
  sha256 "9903203fb95364a8b2774fe4eb4260daa725873d8f9a6e079d4c2ace81bede92"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0a71f4348614a71714f3bae661966e3bae6c30d234f5b887fbf32953c39efc6"
    sha256 cellar: :any,                 arm64_sequoia: "a4d4f41216199da615810de57b142746d9250c1bd358498897b140adf3dc77b5"
    sha256 cellar: :any,                 arm64_sonoma:  "f70416d10f93c0cb2479202290365d407922ae817919c0dbd9bf962b2403f1fb"
    sha256 cellar: :any,                 sonoma:        "7f71e396b11bb72dcb1cd7f5e604d5af2c6a2a24b0db14e21280cb54229fb544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e62004a89ba8f886aa8b7b2cd31336ed9d40ff699257a9ce3655f6fb7c18556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1381bf6e475ce5933e9c36111695f9df2e17073c65e934d518c89cd54c4c74cd"
  end

  depends_on "pkgconf" => :build
  depends_on "libconfig"
  depends_on "ncurses" # undeclared identifier 'BUTTON5_PRESSED' with macos
  uses_from_macos "libxml2"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PKG_CONFIG=pkg-config"
  end

  test do
    (testpath/".config/mdn").mkpath # `mdn` may misbehave when its config directory is missing.
    (testpath/"test.md").write <<~MARKDOWN
      # Hi from readme file!
    MARKDOWN
    expected_output = <<~HTML
      <html><head><title>test.md(7)</title></head><body><h1>Hi from readme file!</h1>
      </body></html>
    HTML
    if OS.mac?
      system bin/"mdn", "-f", "test.md", "-o", "test"
    else
      require "pty"
      _, _, pid = PTY.spawn(bin/"mdn", "-f", "test.md", "-o", "test")
      Process.wait(pid)
    end
    assert_equal expected_output, File.read("test")
  end
end
