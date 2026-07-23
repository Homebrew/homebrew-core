class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.80.0.tgz"
  sha256 "1369762c8e7016bdb6d5ec19ee74f5c49a3c6fce61e89f7d9bb5567b38d4ec47"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "514ec5622f6f35e12420d7327a30abe77100564d82a5f95e8a41c43a55503069"
    sha256 cellar: :any,                 arm64_sequoia: "514ec5622f6f35e12420d7327a30abe77100564d82a5f95e8a41c43a55503069"
    sha256 cellar: :any,                 arm64_sonoma:  "514ec5622f6f35e12420d7327a30abe77100564d82a5f95e8a41c43a55503069"
    sha256 cellar: :any,                 sonoma:        "41107e3a092b63cac64a840905d7d40bed93a0429abf00d2fe4ece917721f5d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "353fc4d02e2848a0dd2539739395de5ad62fa1a55f735e1b988bc441a10cec78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57102896913776612d0a8fdb2f12027d8bd747b83c2483b11c213d538ab3e33"
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
