class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.46.0.tgz"
  sha256 "09417c982d6639e174f151ffe09e01b70b0df9f454c1cf0f351a2fc3ccab5e13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65d442b9a36a1f4c6084c0068d092ed66b5e0587871145bb0f85c7e255dc3797"
    sha256 cellar: :any,                 arm64_sequoia: "962cdb38420a044956211db5fe46d9f725c1a3b663d17cf1d93b184b9771f1b9"
    sha256 cellar: :any,                 arm64_sonoma:  "962cdb38420a044956211db5fe46d9f725c1a3b663d17cf1d93b184b9771f1b9"
    sha256 cellar: :any,                 sonoma:        "4e1010d6494c9c601dcea82d9c321c23b61b4c1dd62dcdaf9663c1e212c5beb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1de18f46bfcfe6b8f70eed8bc3c5284cfd1a4195c92fcd730fac241009c583c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b615dd6444b2650afa50af12d49c4e3c2f44aedfb4babd6a16c18a365a6394df"
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
