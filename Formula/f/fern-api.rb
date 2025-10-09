class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.86.1.tgz"
  sha256 "c8d7b86b4e75967571a3d1627df2a04114c1a4606799f5651e8b34fe1c298a52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa92aee40898aee1a24f9dd0be0059b30d491183789149941fb106ae9a9868f3"
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
