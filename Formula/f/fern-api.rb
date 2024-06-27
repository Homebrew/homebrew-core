require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.5.tgz"
  sha256 "bdf5b82543f630c9ef92b91c145e07af1ee72de4e294d1fe67025c6b3d8b4f56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1366f5190aae9f3ddaa74981ecb29987d1c2498d685842ecd3a2caac728a3a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1366f5190aae9f3ddaa74981ecb29987d1c2498d685842ecd3a2caac728a3a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1366f5190aae9f3ddaa74981ecb29987d1c2498d685842ecd3a2caac728a3a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1366f5190aae9f3ddaa74981ecb29987d1c2498d685842ecd3a2caac728a3a7"
    sha256 cellar: :any_skip_relocation, ventura:        "a1366f5190aae9f3ddaa74981ecb29987d1c2498d685842ecd3a2caac728a3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "a1366f5190aae9f3ddaa74981ecb29987d1c2498d685842ecd3a2caac728a3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b450df7c0ed74ed5f93ad30044e4f494a9bae6782bf8fbc69c66777ce05d3a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
