class Macchanger < Formula
  desc "Change your mac address, for macOS"
  homepage "https://github.com/shilch/macchanger"
  url "https://github.com/shilch/macchanger/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "87192a3549baa771736ec3f9c2017f533d304efc7b7d968aadc1226e08f1673b"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be915a49e29f68f13dfdbc86259fe3edc1a5ae0c06c938aa59560689dd8a2fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c127da61a8720c9996f555bfd159e581e439628d14507d4ca35dcd49d9b94d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc4d071a13a746234f10c4db647be0800d3b6484bf1709815685344c72b62b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d84103330c6ed15cdc830bd581cf0fe62bd6876abac6364aa1fc430c874b13aa"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macchanger --version")
    assert_match "Please specify an interface name", shell_output("#{bin}/macchanger --show 2>&1", 1)
  end
end
