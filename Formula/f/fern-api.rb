class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.65.0.tgz"
  sha256 "fd13b2942a303e0e0103e5fa0b451f52b92538aebe9c30c0661ca7fed898e3b4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "265383c55dc09b8b6e87259810005b70497ad12d9be1021c565bb13170a6bae5"
    sha256 cellar: :any,                 arm64_sequoia: "fa4c35c140cbc9b02eacf7e286ee8c442125df13a0a6e9443e27c1cc79397e9e"
    sha256 cellar: :any,                 arm64_sonoma:  "fa4c35c140cbc9b02eacf7e286ee8c442125df13a0a6e9443e27c1cc79397e9e"
    sha256 cellar: :any,                 sonoma:        "7d324729a7d3c2d26065129e337d59ebd5c6990d72a92de7f61cea2fd89ccac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e225842d45b07e3a3d7be436229facde15f098f4af7fc33562e2b3ebaede5db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98f08e3d8ed2237356bdbc9c2e7e1303221a43acd740edae1c6aea17c5f2db84"
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
