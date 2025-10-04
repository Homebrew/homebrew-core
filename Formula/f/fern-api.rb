class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.84.7.tgz"
  sha256 "275615493fe2cb05f6e102d9b8aab5419c9ee1a0418e186905381acf432738f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b286561cdc552f690b7b69e00fd58f6cf2a3ab0f5222dc57e90522ce9af97a8"
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
