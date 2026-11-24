class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.228.0.tgz"
  sha256 "529b380ede91173b281d114a81cf4516275975b17ffb58ff14e015a878f7fb96"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "a061fba3158e9c7f73c8c902acebe05b20ce08c0add6f5d8042488402b379f5e"
    sha256 cellar: :any,                 arm64_golden_gate: "f29dfc8498f08e2af9c9fa194e99ca448511338afc2d0554d81dae5eb40ea66f"
    sha256 cellar: :any,                 arm64_tahoe:       "f29dfc8498f08e2af9c9fa194e99ca448511338afc2d0554d81dae5eb40ea66f"
    sha256 cellar: :any,                 arm64_sequoia:     "f29dfc8498f08e2af9c9fa194e99ca448511338afc2d0554d81dae5eb40ea66f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33ae83f104518be56044ce6f4d86db66824cc5f8b48b34d8af9da2cff043913c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "71243d935a379a456bcdfb63f867d346b1a26d4696b6064324a5933266c2ccb1"
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
