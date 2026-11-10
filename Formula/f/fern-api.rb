class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.201.0.tgz"
  sha256 "c31bc3afe99ab35e20fc09aac46a63512bf2cc1440c1d26cf85c4c280069a3de"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "aceb72342fe2d7e41057835c1b9d7b9e85710e3d46c2c76e20346aa73159b3f8"
    sha256 cellar: :any,                 arm64_tahoe:       "aceb72342fe2d7e41057835c1b9d7b9e85710e3d46c2c76e20346aa73159b3f8"
    sha256 cellar: :any,                 arm64_sequoia:     "aceb72342fe2d7e41057835c1b9d7b9e85710e3d46c2c76e20346aa73159b3f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb76cae8948c3f0de8ce7a47912aa7abcc9c89782f697a9416943285dd929ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7f33714d4e4a9c9e44b9f8bae48bdb6af377ba35d3a0595d9aad36c7ed6a3ff3"
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
