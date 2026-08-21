class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.100.0.tgz"
  sha256 "e490eed7045f0ef809b95cd12bf498c6b31eba71220d3db2da7958cbec933b6c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82d64a4b981c4d79b2d84d4bb7f4f151f31d254a67e7fb8e613138b2344177c6"
    sha256 cellar: :any,                 arm64_sequoia: "82d64a4b981c4d79b2d84d4bb7f4f151f31d254a67e7fb8e613138b2344177c6"
    sha256 cellar: :any,                 arm64_sonoma:  "82d64a4b981c4d79b2d84d4bb7f4f151f31d254a67e7fb8e613138b2344177c6"
    sha256 cellar: :any,                 sonoma:        "7f9bc116a6bb42968f2a32fab8f26dfaf9777be01370725d5255fc3775fe659a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ad8aa60af5076ea595a29927e45ae577d1453c92fc61dbaf70381615b23009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207bf102eab0b2d3ed8d7d5ec8d70c8c1f7d4d2dd7a5fb757b84dbeb26698bda"
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
