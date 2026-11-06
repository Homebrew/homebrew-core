class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.199.0.tgz"
  sha256 "ece160abcc05202251fc1f165a402c66f4ad9144d05d6b4c6cf4162b4d22e779"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "de9b4d4239639e2a89daa23f01c7b08a0461e80813af9c13926cefb16064d819"
    sha256 cellar: :any,                 arm64_tahoe:       "de9b4d4239639e2a89daa23f01c7b08a0461e80813af9c13926cefb16064d819"
    sha256 cellar: :any,                 arm64_sequoia:     "de9b4d4239639e2a89daa23f01c7b08a0461e80813af9c13926cefb16064d819"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b8e87d789767c8c416bc2b13e9e27ba9cd1070b1d06055bfd569d646ae78fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5f7d56860eb59e464d87826e0e0086e387b522549462a3c9002a1a494dc1ba54"
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
