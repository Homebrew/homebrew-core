class M1ddc < Formula
  desc "Control external displays (USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs"
  homepage "https://github.com/waydabber/m1ddc"
  url "https://github.com/waydabber/m1ddc/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9e4581dc2b3b6b4b1bcd3c8fca5ca45b6bb217a609349bd352751212c0de21e8"
  license "MIT"
  head "https://github.com/waydabber/m1ddc.git", branch: "main"

  bottle do
    manifest_sha256 "c0be968a5788ab8eec3fc9fb16ef25b39040ba4df7dad0682cf36ac234c03b4d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f203efb2d8b0b3b3187a7fdfe9334e85e3b3be094459308c31cebd878e59b185"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5755f7891e4d2c3f6d9f9b257c4e08178c762d88778356434a80c05535c31085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6067f0eba98aa7f2261f1af069d3c39ba6ecbd44adad4e7470e758ad07b855b6"
  end

  depends_on arch: :arm64
  depends_on macos: :monterey

  def install
    system "make"
    bin.install "m1ddc"
  end

  test do
    # Ensure helptext is rendered
    assert_includes shell_output("#{bin}/m1ddc help", 1), "Control an external display over DDC/CI"

    # Attempt getting maximum luminance (usually 100),
    # will return code 1 if a screen can't be found (e.g., in CI)
    assert_match(/(\d*)|(Could not find a suitable external display\.)/, pipe_output("#{bin}/m1ddc get luminance"))
  end
end
