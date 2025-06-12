class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.6.tgz"
  sha256 "2f95063a038fbd60fd62393489d189da09e280c1e6156f71c5a30227a5461335"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e3d204ff1ea46ee55c6e6605c1ce951aa38a9d012fe19821c0648ab55617444"
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
