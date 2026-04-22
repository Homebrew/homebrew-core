class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.84.0.tgz"
  sha256 "407bd6e6223b0ac8b917e74c38529c97cabe53c3d3d7e1dab3a2b77db7fea689"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90c48a2c8e81d17d557f2326a62229730d869ed2f52fb7355bbdb6d941506f2d"
    sha256 cellar: :any,                 arm64_sequoia: "d6c640a38b45c4062d0fd0d97ae3d8a667de71dba3a75058fa6676d61ae71489"
    sha256 cellar: :any,                 arm64_sonoma:  "d6c640a38b45c4062d0fd0d97ae3d8a667de71dba3a75058fa6676d61ae71489"
    sha256 cellar: :any,                 sonoma:        "3bf98da3508c046a4b5ed3057a691e71f7b1397ca7666c2f98a797ba0a9cc409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f88fb5b408c8e0209f7f42900b947a439ad85da5195b2a626ae4fcdfa7794758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557cd2b8787eba7d34adc07736f2aeb42e01c1109ffbaedc387a4a01723beafb"
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
