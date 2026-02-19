class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.78.0.tgz"
  sha256 "12a7385f5a645f9d8851e09fde9d9461d9cceced27bb6c41c515c4bc7b21a6fb"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85a78a065fdec4728c9edc5353615aa59e6cb9a59ac1ce25f5e9a388a5fdfc00"
    sha256 cellar: :any,                 arm64_sequoia: "1d04530c1b75201d51be14808c8e90d3e0c292bbb67943a3114fb710c18c0fce"
    sha256 cellar: :any,                 arm64_sonoma:  "1d04530c1b75201d51be14808c8e90d3e0c292bbb67943a3114fb710c18c0fce"
    sha256 cellar: :any,                 sonoma:        "fd9ee3154d65af51509ebd193a31073d2a538f25a05a5e9489fcc783764d8ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a047db131c9b4ccf38668e7df74c4fba1e20f0e316809641bd9baaecef41f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ab81aa689172d84dfe167c8696a3005fee4726390b25f463e3dc8cdfa8e3a2"
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
