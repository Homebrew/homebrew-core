require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.22.1.tgz"
  sha256 "3bddf569de988fbf5a3c1b433f0df69a329be795b42860d84ebf8ba5cbd67c81"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba8e456c8e91937a693453955c1705ae62e294c20cba7bfb7d4655556254873b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba8e456c8e91937a693453955c1705ae62e294c20cba7bfb7d4655556254873b"
    sha256 cellar: :any_skip_relocation, monterey:       "cae7542642baec6fbde1753709a2d85eb8367e9f6a826eccb17e4ac7114cac2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cae7542642baec6fbde1753709a2d85eb8367e9f6a826eccb17e4ac7114cac2c"
    sha256 cellar: :any_skip_relocation, catalina:       "cae7542642baec6fbde1753709a2d85eb8367e9f6a826eccb17e4ac7114cac2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8e456c8e91937a693453955c1705ae62e294c20cba7bfb7d4655556254873b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
