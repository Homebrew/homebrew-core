class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.13.tgz"
  sha256 "afc3ebcc51e3074112b2e68c867655474e7d5c6e4728fb96e4841cc96b415b32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe3f3e74564e82439d1d62684cc52c356e83f2ed412e4348f21805882bf39671"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe3f3e74564e82439d1d62684cc52c356e83f2ed412e4348f21805882bf39671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe3f3e74564e82439d1d62684cc52c356e83f2ed412e4348f21805882bf39671"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e92b8db502299caac2c8d51e940205d90af85a237fcf9f6485d84f9428e9adc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "279faedc4394b709cbe91be7e5f77ac2ea811e79bad8f9ce2ad94ee379d686b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
