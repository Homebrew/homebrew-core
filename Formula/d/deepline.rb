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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df199771661489842eb1e3824679c5f39298221ca6013f545d4efb9ce1e4236a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df199771661489842eb1e3824679c5f39298221ca6013f545d4efb9ce1e4236a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df199771661489842eb1e3824679c5f39298221ca6013f545d4efb9ce1e4236a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a32ccf319c0ae04c84504b6bbc42519b2e501acee6dfbde6aceaf949fd6c3fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "01022870d42bb5176c01fba61d85f2d2dece14d39f23c8be5e5c0df2dcf482ac"
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
