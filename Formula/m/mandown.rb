class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/refs/tags/v1.1.tar.gz"
  sha256 "870e3fa2bd6b8ad5d2259e7ef30a69d4faa87ef6cad7b2d8e34dc4944b651335"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3b449504af7e4a74813ded40c61badf79bf0d6f4b9aed15b50c26a4472516df9"
    sha256 cellar: :any, arm64_tahoe:       "67c94490d14924523d9bc259f691e3a03f2f3690fd1afef13b566c8379c1d41b"
    sha256 cellar: :any, arm64_sequoia:     "ce8872683a7e2b3d9548dffbe16fd41b35ef17f697fc8b4dca2e2d6bd28c84e8"
    sha256 cellar: :any, arm64_linux:       "40e8f060fd999cc97f247638208efa477b167beb79ea12490fb69b17636105f8"
    sha256 cellar: :any, x86_64_linux:      "8aa1f669babd02383fa44403a1d1465d9565d80fafc1db71df83d552e0470781"
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
