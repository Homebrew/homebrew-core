class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.102.0.tgz"
  sha256 "5b29a0cd88c0e1ac22a63558e04a11af85248b30f2024fce98c4fec5387da5e9"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56ed58375465ba49fb0d21066640d303b3af01ab757a7f86a2007e5d44d8096b"
    sha256 cellar: :any,                 arm64_sequoia: "56ed58375465ba49fb0d21066640d303b3af01ab757a7f86a2007e5d44d8096b"
    sha256 cellar: :any,                 arm64_sonoma:  "56ed58375465ba49fb0d21066640d303b3af01ab757a7f86a2007e5d44d8096b"
    sha256 cellar: :any,                 sonoma:        "90b49227efef28aa09479fdbbfd2cb7bec18d3689f61ab0f43a5155fb5bd98b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a7b9f12faa5373cb5e9093459f2fb7e092921fd835d6b018767b7121d1e1bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a64f6f74a680a0b962b21f0ade4b040eed075ea0cea8d58bc7f03d228b4bd9"
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
