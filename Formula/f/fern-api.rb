class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.107.2.tgz"
  sha256 "7ae11e0db645fd221c6d4aa08227b366cc4396ab7f643472a405a4043282ffdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77a97fd18486e6c4cd7d28366fb822a0965ddd8c4db9b2c2aed8346b722220b1"
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
