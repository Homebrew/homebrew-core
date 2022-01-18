require "language/node"

class EdgeImpulseCli < Formula
  desc "Command-line interface tools for Edge Impulse"
  homepage "https://github.com/edgeimpulse/edge-impulse-cli"
  url "https://registry.npmjs.org/edge-impulse-cli/-/edge-impulse-cli-1.14.2.tgz"
  sha256 "ecbd5eb1b5acad313db98cf326349bab6a13f663146f3726bce0f497c30991b8"
  license "Apache-2.0"

  depends_on "python@3.9" => :build
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Invalid API key", shell_output(
      "edge-impulse-uploader --api-key notarealkey --category training path/to/file.wav 2>&1", 1
    )
  end
end
