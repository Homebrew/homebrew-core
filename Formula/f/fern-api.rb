class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.230.4.tgz"
  sha256 "a2c4943affe91b808ebe91ec7900ebe361d287f06e881adffe51e1fafd4bd6de"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "9b2bfedc23324a4ae5db3b03d600d0e1c723f394dcd3f789c4110b62d552bfe7"
    sha256 cellar: :any,                 arm64_golden_gate: "962f8dffec2df800295f02052a47460ee4b1bf97b185d34c054aa958986588c3"
    sha256 cellar: :any,                 arm64_tahoe:       "962f8dffec2df800295f02052a47460ee4b1bf97b185d34c054aa958986588c3"
    sha256 cellar: :any,                 arm64_sequoia:     "962f8dffec2df800295f02052a47460ee4b1bf97b185d34c054aa958986588c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5530f8b460f8a460991f706e6f87529cc80dc85bc0cdc0413d91fa2cba3d990c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d244357291133e1b30591af9e6b5e1b2d661638055a6d01562a6c152227fd3fa"
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
