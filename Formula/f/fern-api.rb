class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.6.0.tgz"
  sha256 "9b6ad46ce37ca9511f3949f8ca2b7c2db4f72a8273f2f0adc56b4c724f58b859"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eec0b02cf0e949b1d730212f93cd38db847c1cdd2993656bf7510c6425220130"
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
