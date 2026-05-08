class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.20.0.tgz"
  sha256 "6bf9c55001131cb5cd26575b3dc9db4df056b0d1dbc8112fddbc141b97c0e10f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2711dc80547e5e06984d84488b567d7d8a5fab3ef4e054f0adb82b05edaef07"
    sha256 cellar: :any,                 arm64_sequoia: "2367eb150202aeb15ffe731e36d7bb2c245267ef9e68c37e56735694a94a9f5d"
    sha256 cellar: :any,                 arm64_sonoma:  "2367eb150202aeb15ffe731e36d7bb2c245267ef9e68c37e56735694a94a9f5d"
    sha256 cellar: :any,                 sonoma:        "d4499516c73b9b35fc64d09af635469aae4c33eda2458bca4389fc6726dffa35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0fe6f91f474313bd94f767a0854ff7ab2062b0b7cdba417206369a86846756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e83ec87a9e4e61ebbc860bfd8e2d06d1170d72e65b6ad7b8d195ca3282fd9f7"
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
