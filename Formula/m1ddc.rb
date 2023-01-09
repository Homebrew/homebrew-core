class M1ddc < Formula
  desc "Control external displays (USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs"
  homepage "https://github.com/waydabber/m1ddc"
  url "https://github.com/waydabber/m1ddc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "884b65910e69915db29182363590d663a1a6d983e13ca5c41a74209058084c44"
  license "MIT"
  head "https://github.com/waydabber/m1ddc.git", branch: "main"

  depends_on arch: :arm
  depends_on macos: :monterey
  depends_on :macos

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
