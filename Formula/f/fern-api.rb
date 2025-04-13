class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.24.tgz"
  sha256 "46a9ea178d834ee887eb20fa90d7a80d0a4ef5aea22d9c04908519a67755ff70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73ae12b639fa352d2c56d9ba3872f85e07a673da14efd8a9f8f8e7daf7220f92"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
