class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.9.tgz"
  sha256 "31ac2e088d2820924cb430e3316bf87053f29a94d0c4c9daee48cad7c3328692"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6aa07479153557d00a77c62598ebfba46402b5e4248f87d69ce39c8d567327a9"
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
