class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.17.0.tgz"
  sha256 "575767004d5251a7e1a2c1b0394cc779316f2f3f4a7eb0c8749f8f94113ac6dc"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8260e0ca9b30c98ba948045ff171fb7fe3c29108c9ae23bec28f3e8d273991c1"
    sha256 cellar: :any,                 arm64_sequoia: "0ee3da4af9dec5802efc83a46b41985df897fcda9a487b913a613ee9422d9442"
    sha256 cellar: :any,                 arm64_sonoma:  "0ee3da4af9dec5802efc83a46b41985df897fcda9a487b913a613ee9422d9442"
    sha256 cellar: :any,                 sonoma:        "f1b5d6ce23a1c209cfcf791221a17ea2df58c2b914f4f39a256bd79858be63cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "111517dcc9c20f3d8f70977bbca4c55dd81ea5aa90bf359a3b7f89a136560fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ac1110d2ef24d9dbf4fde3e4104838ad7d9109e963e66aee33d7d7d6682bb1"
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
