class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.219.0.tgz"
  sha256 "b0da0a1537aa8b943492e7204be8f6a46ac07b2de85ed9c1ad0f4b41ad0310c2"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b5a1e9d55d1537e4b4bc0377efefea3ca3eb833fb9859784e1f3d978be53f620"
    sha256 cellar: :any,                 arm64_tahoe:       "b5a1e9d55d1537e4b4bc0377efefea3ca3eb833fb9859784e1f3d978be53f620"
    sha256 cellar: :any,                 arm64_sequoia:     "b5a1e9d55d1537e4b4bc0377efefea3ca3eb833fb9859784e1f3d978be53f620"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b8f2a4b6c2b1e9ef3670b3e76ef0b17e602d2cfe875349257df2bce924b6447d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "833d8df682ba9a7ef1b9cd7a472346f24c8e9a1f87b2dd73c7c99fa2079941cc"
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
