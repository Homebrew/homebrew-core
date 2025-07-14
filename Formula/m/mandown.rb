class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/refs/tags/v1.0.5.2.tar.gz"
  sha256 "9903203fb95364a8b2774fe4eb4260daa725873d8f9a6e079d4c2ace81bede92"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62058c08be40e955aa5a9092da1b9c5975391f1715432219bbe6dad514c681b1"
    sha256 cellar: :any,                 arm64_sonoma:  "d343e0a1552d905a9fcd584e61c76529bcc8d26d91974b93b29ec0af577f7291"
    sha256 cellar: :any,                 arm64_ventura: "51097a822ac6600795f5edcc3731477189e06856cf244d8d21ba6c0ff565ac26"
    sha256 cellar: :any,                 sonoma:        "2bb2bfe9ada4cdbb8c6a6076919aeaff49d7cc62624370f887193b55dd7963f1"
    sha256 cellar: :any,                 ventura:       "ab61a2e08c5a47dc9cac7f6dfed509bae5bf0b4639710b68bbb8b2c4414d1c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57dfe62d68152f7084d3a6e565ad0ff2dc182e78134938d16e73fd8a845c310e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0629af3814a1f1ddb1db8d5d1c2fa110114b959899dce4b8e4e3261e91469c4a"
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
