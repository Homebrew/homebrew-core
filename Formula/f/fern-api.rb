class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.25.0.tgz"
  sha256 "7d8c6ba617dd1b05b25957347afdf5a25e0a6b477c7b83d03b1943efbee7c72c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "000d25a36289b9df05ebdf55bbda8989915d33b0c44cf9116f4e892f8ded34b2"
    sha256 cellar: :any,                 arm64_sequoia: "009b31cd0cce17e2aacaf867f6e3546c873b6fd3764193c8ef9f400af5d93c2b"
    sha256 cellar: :any,                 arm64_sonoma:  "009b31cd0cce17e2aacaf867f6e3546c873b6fd3764193c8ef9f400af5d93c2b"
    sha256 cellar: :any,                 sonoma:        "1d981935f33a937e43592362c69caf288d3a1d1b28b350666a265dc5f5ad1b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aa8ce19dcea1969987be5867ea1be9e98a20ff9000bbf4ec448237541532fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fedd2c17f42ac6f7743cfce681c925f4af1f2e110947da390f14b99a100aa4"
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
