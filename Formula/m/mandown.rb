class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/refs/tags/v1.0.5.2.tar.gz"
  sha256 "9903203fb95364a8b2774fe4eb4260daa725873d8f9a6e079d4c2ace81bede92"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16dc6fc0dce771f2568a38212dbb8ee9a4c262d737e83ae2a05575f1f29931bc"
    sha256 cellar: :any,                 arm64_sonoma:  "7ae97c8f48213d8aad67e3d9edb24d832569fa69487a4fb7c1db3447b2a024c8"
    sha256 cellar: :any,                 arm64_ventura: "24b373ecb63b84230f0f86f745cb4249239a042b32ab1cbfd40605078460119d"
    sha256 cellar: :any,                 sonoma:        "6992cc1fe420af48147fb1a65db14b4c802977e42d5398bd794761c735131d53"
    sha256 cellar: :any,                 ventura:       "8eae3a3b31cd0d843b6ff09dfe3469ec3bee7767a51fcb39c189de9f6526148a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f3e1393953047b195a1393c6ff664ed8ca7c9b96dc0d510acd7b4b3ab05cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f23f558c76c49fff56ffa50d019c8866b34eb3314a038e4229d12cfe6036fed"
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
