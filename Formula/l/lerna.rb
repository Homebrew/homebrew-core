class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.7.tgz"
  sha256 "c98524665b4c4836ac7a88e18c7c24a46f5fd6bf3833a40c576788fdd45bef3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90e31832b1407d7276b03a688cdceaf4d0d07baf983b731696889dca2802fa7e"
    sha256 cellar: :any,                 arm64_sequoia: "88c230c1915d25f30dc8dab5cd7f3c86ebd4f76eac0ef4725caf28236b8447bb"
    sha256 cellar: :any,                 arm64_sonoma:  "88c230c1915d25f30dc8dab5cd7f3c86ebd4f76eac0ef4725caf28236b8447bb"
    sha256 cellar: :any,                 sonoma:        "93ebef6b1abaaa328c74bd6ceccf9d2d10ea02a9e95e454a53c03311bc21e75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "559588a47d384e09594421c37427be9db253c13eab16007950a8d48818304bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5416abeca4ee5099817f6f9a54355f287f7c3471d6364170e96eeea1b100e4c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
