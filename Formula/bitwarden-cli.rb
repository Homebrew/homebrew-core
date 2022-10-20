require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2022.10.0.tgz"
  sha256 "93a952c653577a388ba29821edccd6db62155cd267e2a46c808aa77c48b47b14"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18f0983eb6a713f18036044de190d49a3f74640dd54885e3894ee4b67b06e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d18f0983eb6a713f18036044de190d49a3f74640dd54885e3894ee4b67b06e18"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcf5389168cf338b5a34535d7a0fb31901cfc553c98b47dbedd8855081c4368"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fcf5389168cf338b5a34535d7a0fb31901cfc553c98b47dbedd8855081c4368"
    sha256 cellar: :any_skip_relocation, catalina:       "4fcf5389168cf338b5a34535d7a0fb31901cfc553c98b47dbedd8855081c4368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18f0983eb6a713f18036044de190d49a3f74640dd54885e3894ee4b67b06e18"
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
