class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.500.tgz"
  sha256 "f453267103d4831580da960c970f434e1418831c489900d5c20a78574c47f7b9"
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
