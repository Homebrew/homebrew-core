require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.7.tgz"
  sha256 "716b2e6740da75fbea7b2c57bbe24556240ed559430e39c5fc3c78015d3aa50c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02adc9a91e83198ccea66c9a0f17964cb85d40ba1bc4187e8329bd7194458088"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02adc9a91e83198ccea66c9a0f17964cb85d40ba1bc4187e8329bd7194458088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02adc9a91e83198ccea66c9a0f17964cb85d40ba1bc4187e8329bd7194458088"
    sha256 cellar: :any_skip_relocation, sonoma:         "02adc9a91e83198ccea66c9a0f17964cb85d40ba1bc4187e8329bd7194458088"
    sha256 cellar: :any_skip_relocation, ventura:        "02adc9a91e83198ccea66c9a0f17964cb85d40ba1bc4187e8329bd7194458088"
    sha256 cellar: :any_skip_relocation, monterey:       "02adc9a91e83198ccea66c9a0f17964cb85d40ba1bc4187e8329bd7194458088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45e6438c4a41123cd1581899dbb826c565c8646d83a4dd7d27e11d1e8d69826"
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
