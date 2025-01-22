class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.16.tgz"
  sha256 "06d6787be30369d7263cc7f1b21bc086862003194e06bba35fa91b109ae167ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "457f79d96bd87418a23cfdf284daba697e3b78734f9869f90374c2048b8e7e03"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
