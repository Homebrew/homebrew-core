class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.97.0.tgz"
  sha256 "d9dde30f92e218244bb3089743a67a4c37cfb2eb2a5717fbbe18d4b1ae9c47ea"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62af123d7a31124b0f11d70a77d93fa4810b610b05ff57d7108259306834e01c"
    sha256 cellar: :any,                 arm64_sequoia: "af71143a7c76547fa38a6b736150bad84368e7fbc2bd8f0b9947e2393a9acd0b"
    sha256 cellar: :any,                 arm64_sonoma:  "af71143a7c76547fa38a6b736150bad84368e7fbc2bd8f0b9947e2393a9acd0b"
    sha256 cellar: :any,                 sonoma:        "29d533819e800bf3ee0f4894826edb39bd6f338bdef3cf2cc8447c84d22849b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d2dc486ecb54841cbb7d4b49dd901886bf1d404918fb991ae6995187d5f9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca196898758df89c3a9155f2ff2bcbb33f16a6916ac024361dcfa5acc1702699"
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
