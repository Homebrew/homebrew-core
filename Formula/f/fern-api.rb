class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.42.0.tgz"
  sha256 "28e74312007bfba2ccd7526b110d87d258dfbd430341d66cf142419414d8beeb"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6728b496f7804790cc655a4f7ab62cb3f88175390318830a771c5ab34338a87"
    sha256 cellar: :any,                 arm64_sequoia: "2809caf5d0a065bd0ba2e58bd3a087097d42a5247ed06b88fa1c2c2f25a86f58"
    sha256 cellar: :any,                 arm64_sonoma:  "2809caf5d0a065bd0ba2e58bd3a087097d42a5247ed06b88fa1c2c2f25a86f58"
    sha256 cellar: :any,                 sonoma:        "688dd875dbfec2273655fb7b55b8bd8ebc0794e04de819512d661d5baff91489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a78ec45ad3709d02db8ccec25f5bb77ade5de0dec2c9c491dce4690b43a5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3eaca00968c482cddc6146e89856e5a3e27c7958776f5573f56a99e8f3dba2"
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
