class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.78.0.tgz"
  sha256 "54d9a38750934543e33b3ba847b8e801db873c10294bce66b29b38d5aa3e060e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c008c22568e7f944554972b2e8049f848ff27b3530dfbfd484e43bc83859b7e0"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
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
