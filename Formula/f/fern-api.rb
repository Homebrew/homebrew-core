class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.83.0.tgz"
  sha256 "a2748d47129d51720fd0a8b043e179e0433d40159191720b00f920642c8d7a6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22a5babd472d692c5f0deb4364db82862cae5180fcf1a653d3a1c4bc1c979818"
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
