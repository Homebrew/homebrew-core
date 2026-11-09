class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.489.tgz"
  sha256 "de7c4115515311f41b6f00a1ea06698c2223eb6521da7a99b0d818260cff4b9b"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd2705b3ae1928952a50e61b69b51d27fe0aa39a3da8d9c378b9616a685afa67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd2705b3ae1928952a50e61b69b51d27fe0aa39a3da8d9c378b9616a685afa67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd2705b3ae1928952a50e61b69b51d27fe0aa39a3da8d9c378b9616a685afa67"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92a76b995d31cc92cdcd006ad453b49b0764ca50dd8d3be3b1d5d1d5fb051ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d63b37b36baa22ef050831342de1f2d9bc1dd9127315c16bcc27658d010274ac"
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
