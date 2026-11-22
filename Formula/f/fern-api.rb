class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.227.0.tgz"
  sha256 "f6202d70969fe367f5f51db5d778a0a496c6d73e1f270f377935c1f59e3fa4ff"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d84dd0d31a51ebcf03d5ac99a769cc66834a372773220a8c7d5ae35789a615d8"
    sha256 cellar: :any,                 arm64_tahoe:       "d84dd0d31a51ebcf03d5ac99a769cc66834a372773220a8c7d5ae35789a615d8"
    sha256 cellar: :any,                 arm64_sequoia:     "d84dd0d31a51ebcf03d5ac99a769cc66834a372773220a8c7d5ae35789a615d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "645cfb4d481d669d27175d099cc556952b419084d4cd76e0d8c176e34227e11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5887488a3e2b30329c12356423f323f4c629013800d4c9e197419ba1155f03b"
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
