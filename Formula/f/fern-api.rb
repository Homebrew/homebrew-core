class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.230.2.tgz"
  sha256 "b4bc7913ff897b1fb0aa25472a1d7ba92cd8651e9c2f9211e40f6a25b41c9f97"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "c703200f1417c5aa2de3dc1c0a30b213045c72e794dae1189f4ab87dc7e47f5e"
    sha256 cellar: :any,                 arm64_golden_gate: "95e84ca8867eb1dede13fdde4a63833bf285776131e8738541525846dd980814"
    sha256 cellar: :any,                 arm64_tahoe:       "95e84ca8867eb1dede13fdde4a63833bf285776131e8738541525846dd980814"
    sha256 cellar: :any,                 arm64_sequoia:     "95e84ca8867eb1dede13fdde4a63833bf285776131e8738541525846dd980814"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac7324dc6603961a3e08e810c5a77fc7ae3068ca1288bc2a25d8d69be6abf8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b74854d0ea13d2c6a68529d203f2bf7fc31b7dce209b1b01f41ab4eb36c38590"
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
