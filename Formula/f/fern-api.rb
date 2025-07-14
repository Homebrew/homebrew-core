class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.11.tgz"
  sha256 "5fdab24c46d86af2c72b63293ad39a783cc94e8523df185ca7a09fdf2994107a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5fd5bd28d956f92556146e1ccaa1b328de3cb403c003b9fcfb2badfaf0b37ae"
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
