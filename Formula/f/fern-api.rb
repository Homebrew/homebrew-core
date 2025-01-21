class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.13.tgz"
  sha256 "b502ce8d14843e870c5c1e0bb628180560f59a243c4cdb8b98873074ab68e6ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af9e6fb4640b9b7808888b92a839809e0f1e0a53dad30889d66a160b36d6b164"
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
