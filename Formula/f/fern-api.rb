class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.77.6.tgz"
  sha256 "053000ac3d86fff89fab5175d5850ae2a6e92cf942b84c7b3560b96715aa5adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fdc044adeff497bfca7c2819a26f8d4d1534904969a02b6974befe9da03c316"
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
