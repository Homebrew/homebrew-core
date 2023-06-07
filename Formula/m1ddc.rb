class M1ddc < Formula
  desc "Control external displays (USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs"
  homepage "https://github.com/waydabber/m1ddc"
  url "https://github.com/waydabber/m1ddc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "884b65910e69915db29182363590d663a1a6d983e13ca5c41a74209058084c44"
  license "MIT"
  head "https://github.com/waydabber/m1ddc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e81833fe542690bd540109b71b584e72105b9a52a2f39c8f8864d7b682d16db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb0437173b2133d7312cb91a73dfc0f25946f79ef94ca365025e1f4034c7edb"
  end

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
