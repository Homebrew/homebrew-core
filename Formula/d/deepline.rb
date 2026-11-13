class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.505.tgz"
  sha256 "414d624dd8571af9349ce2f7c53b0e3fac7c27866e8043a2066ff5059065430c"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a0354596b574ad8ba5f386546db9e1aeab2f03a553b6591a18fb3d51114a47d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a0354596b574ad8ba5f386546db9e1aeab2f03a553b6591a18fb3d51114a47d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a0354596b574ad8ba5f386546db9e1aeab2f03a553b6591a18fb3d51114a47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c20c50ecb7220c27a1295ee1fc6815d160606b686995f56f5ebaad9ec461ca04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3456d803cf6b1e8fd749f2171b345c7b7afa4ab485a70348e62fccd5cfaea54c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder --json")
  end
end
