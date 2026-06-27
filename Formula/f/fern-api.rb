class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.55.0.tgz"
  sha256 "f78e309f23f09a295e27b63677344f134ea4d81758d73204c50212e428a227b9"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11ea8b12d3f3c66bb3536684c94b33bb3478678324cbb0461dcd627827d9222b"
    sha256 cellar: :any,                 arm64_sequoia: "aed32fa8c2f5fc2bc136661565a2cf84ee0f5a116eebc5338736b86146d70cea"
    sha256 cellar: :any,                 arm64_sonoma:  "aed32fa8c2f5fc2bc136661565a2cf84ee0f5a116eebc5338736b86146d70cea"
    sha256 cellar: :any,                 sonoma:        "bd12a72489c9e7cb5aee780c37fc2fe1c8a2ee7c2947412a6a751dc75435856e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6faee2e6a4bd535cf9c519cead7ab1f4f7bd0c344c2b675438278042765bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb1503acce208e4b7200ff11017ed3c5b678ec215c1b1b6d7ad737428ff5591"
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
