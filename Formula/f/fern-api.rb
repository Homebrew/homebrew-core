class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.35.tgz"
  sha256 "1e9e43fea724bc3d18fa1f82d711dd59f3b4e54a8fb5740bd49059cfb8f40a6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "645bb27ff8c7b4b2da599fa76d12b61e10c45941a913d1336c81411c378c4e69"
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
