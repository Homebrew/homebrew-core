class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.80.tgz"
  sha256 "677bb865aec7968afde547e6e9b6a68f0c0de50d000e52067e8789ea4006bc47"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "066b4ead1f67f185799e07c7906de35e5f3e1ad4a52bde04cb60b471208e1af2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066b4ead1f67f185799e07c7906de35e5f3e1ad4a52bde04cb60b471208e1af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "066b4ead1f67f185799e07c7906de35e5f3e1ad4a52bde04cb60b471208e1af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23303e63aba00d91dbbc7ff1ddf2299b516d5dd0d9f22bdead8b9f3493c6da79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c424649af3394e437b6cabc6084869acb5aab23dbc949e9505c3522bbf9237"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
