class M1ddc < Formula
  desc "Control external displays (USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs"
  homepage "https://github.com/waydabber/m1ddc"
  url "https://github.com/waydabber/m1ddc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d12bf9e59f9e9a09a0b6fd54bcf752cdc01dd3a8dae3df0bcaa0abf8dcf6d388"
  license "MIT"
  head "https://github.com/waydabber/m1ddc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32c4d9d4e0a0d82987fcabc9be2b50cf4cf1e337a4298716661fc5d9f95240ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57d37f11b7462723c39bc458373a787bd3985be8d32c13147b14abf054f4d0d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38e78577f760384b60762ae7cbd8e658d5a846ab82ab9c07b6dea33f228cb258"
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
