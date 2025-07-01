class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.29.tgz"
  sha256 "d39f18c1bc93d6b56b6498b774e69bd3a465d8406bcb35f90c30ffb55e28922d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5e3664561cea074d89a3efb17b57706aae5979daa7a6691271933dc8084f946"
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
