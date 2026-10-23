class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.171.5.tgz"
  sha256 "77e01be3621e7f314a1275625f525774aba2b6ff59f5781efa81ec3c53292a6f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0a1efdd93f026386309f028d6f1b796fcd281c7f3051f24fc73473e9af74d945"
    sha256 cellar: :any,                 arm64_tahoe:       "0a1efdd93f026386309f028d6f1b796fcd281c7f3051f24fc73473e9af74d945"
    sha256 cellar: :any,                 arm64_sequoia:     "0a1efdd93f026386309f028d6f1b796fcd281c7f3051f24fc73473e9af74d945"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92a3c19906c7f289aaef27b715c930aa12fdf30ebe2ec6bbf35f4834988c17de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ce4dc83801529d79e69d38e7ec4eeb1140e0d3ac602e50b9f0f93d9d40760c19"
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
