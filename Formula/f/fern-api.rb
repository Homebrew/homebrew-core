class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.52.0.tgz"
  sha256 "13d76223f2209d3a415c9c20c11262642c9bb74f6e9d05233f3df4f643dd130f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "309b14236b4244481aa316f566e87d9e3fc32506c02d598c922ca4b04c55b0e8"
    sha256 cellar: :any,                 arm64_sequoia: "22700b81862faeb8f2d9fd60bf9e2fbb0990cdce7c1d7b39d358fb358ac04de8"
    sha256 cellar: :any,                 arm64_sonoma:  "22700b81862faeb8f2d9fd60bf9e2fbb0990cdce7c1d7b39d358fb358ac04de8"
    sha256 cellar: :any,                 sonoma:        "53d2bd2d3bdb04a782d926eb22c5fdf7ea87b1e7027a8465d6884bdd106f3313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa04a2647066df59f2bd50985c013194295f694b79af6d6b0aef0c99acb3d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63d57e98cc6ea90360525855049cbce0e2d5dce52a221b86e4f3e2bbd262c80"
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
