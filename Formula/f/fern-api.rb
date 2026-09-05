class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.114.0.tgz"
  sha256 "f0a1e28c75db907e2581a08da1773c9f0a80a8993e1503a2d336b2ea77ec05a5"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ce859cddfae5477f928e796fde11261d50fd6ffba3beba4444fe7e79c5dc64f"
    sha256 cellar: :any,                 arm64_sequoia: "9ce859cddfae5477f928e796fde11261d50fd6ffba3beba4444fe7e79c5dc64f"
    sha256 cellar: :any,                 arm64_sonoma:  "9ce859cddfae5477f928e796fde11261d50fd6ffba3beba4444fe7e79c5dc64f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b5e6f198a5a8957fb0855cb2c38cc870dd099b3af3643a527aa204dc2fb9ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d541c8c3e79b9740b7fab393261a161007421f66c6549a662dbb8b12e9a9ed"
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
