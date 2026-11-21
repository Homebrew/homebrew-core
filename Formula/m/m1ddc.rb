class M1ddc < Formula
  desc "Control external displays (USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs"
  homepage "https://github.com/waydabber/m1ddc"
  url "https://github.com/waydabber/m1ddc/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9e4581dc2b3b6b4b1bcd3c8fca5ca45b6bb217a609349bd352751212c0de21e8"
  license "MIT"
  head "https://github.com/waydabber/m1ddc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3867b5ab27b555067acddeea26aba450679dfa2c980b1f3b96c895ed2d834019"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5f214e6c142610187513ef1756b281a7879ca8402feea6420c9483a78ec7ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0a276f5e6d1f9f8ef3cf05a7e118fc8b72236678cb79f4ad5bd47dda8735739"
  end

  depends_on arch: :arm64
  depends_on macos: :monterey

  def install
    system "make"
    bin.install "m1ddc"
  end

  test do
    # Ensure helptext is rendered
    assert_includes shell_output("#{bin}/m1ddc help", 1), "Controls volume, luminance"

    # Attempt getting maximum luminance (usually 100),
    # will return code 1 if a screen can't be found (e.g., in CI)
    assert_match(/(\d*)|(Could not find a suitable external display\.)/, pipe_output("#{bin}/m1ddc get luminance"))
  end
end
