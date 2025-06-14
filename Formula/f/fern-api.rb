class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.8.tgz"
  sha256 "336599e9bfa788d3632053b9c7888fb43c000583139eb1e379bea607f0737d93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65d6602a5a1ff9a132465fa75ae0d35d08b17949cc9263d171956dd6914318eb"
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
