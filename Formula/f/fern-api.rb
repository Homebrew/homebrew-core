class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.108.0.tgz"
  sha256 "6b0ecb6b9f415109f59374012d9fa8e30a80be5cd8cea31deff5903c1883b73d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd738e848b45abd54246e8c1f438e6128395dce41320bfa44b54b92dff9b5161"
    sha256 cellar: :any,                 arm64_sequoia: "388167092bf22b9cc80b9ef24c9c67605b0540cdd0f9715e9bc9446e59deb4ce"
    sha256 cellar: :any,                 arm64_sonoma:  "388167092bf22b9cc80b9ef24c9c67605b0540cdd0f9715e9bc9446e59deb4ce"
    sha256 cellar: :any,                 sonoma:        "79d77ff8b76601e5bc1c49f7ef8e046964649c0ca7fe003adc70dab41883a60d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ac50d9aa8028991ef06b1a31cd5ddfb693114679feb0983e69e3f5caff11a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9defbfd1bfbb30f6b6fb266cf66778205f4a5ad06cf59fd8a08c26562ad62581"
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
