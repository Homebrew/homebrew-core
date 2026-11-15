class M1ddc < Formula
  desc "Control external displays (USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs"
  homepage "https://github.com/waydabber/m1ddc"
  url "https://github.com/waydabber/m1ddc/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "2cbf3d41e4d68de7c38d21985e12b591f9572cedfbca2649aa54044bfdced705"
  license "MIT"
  head "https://github.com/waydabber/m1ddc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc3bb67c1d7cb3122c3362c23c1575ecc66c57820d012a8f5a3645dda2816782"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48b4c5e7bc6134ad04f1ee7967165da49ea94d116f24a71df8074a8738b15dd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da366e34b8b35c9a62639ebb9584bbc5b07aa9047d755b1921b7b552bdbba3de"
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
