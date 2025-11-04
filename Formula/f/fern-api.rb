class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.107.3.tgz"
  sha256 "909a1015874f32dc2c1de59a9ac1c860dc73f6086fb41d7464de9b00d51b6ba2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85e5ac77170889bec6f8098362da9a69cf36151d92b042e5d114291ab6df7fcb"
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
