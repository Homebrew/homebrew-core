require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.16.0.tgz"
  sha256 "76bf35f44ec3bca00b2e5a1fc70c551487a013b5219502c3556a3eb9e83642cb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32b5330b34919c4ab24ed3664ba999653c8709ed8aa746879973976e1ae56d7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c30487ca6325ff18712f84ef2f8352c22eecab3a29a8f225b86fd7959e838b1"
    sha256 cellar: :any_skip_relocation, catalina:      "2c30487ca6325ff18712f84ef2f8352c22eecab3a29a8f225b86fd7959e838b1"
    sha256 cellar: :any_skip_relocation, mojave:        "2c30487ca6325ff18712f84ef2f8352c22eecab3a29a8f225b86fd7959e838b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
