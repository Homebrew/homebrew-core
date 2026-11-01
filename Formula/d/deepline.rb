class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.453.tgz"
  sha256 "34674599dc4dce2f393b55ba353f889fe94cf03381d58a342ddd4d89db6f1480"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08f38be6e806737b3cbc1b025b7517bca39e4565fe6f46ebcd4524436b5c7ec4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08f38be6e806737b3cbc1b025b7517bca39e4565fe6f46ebcd4524436b5c7ec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08f38be6e806737b3cbc1b025b7517bca39e4565fe6f46ebcd4524436b5c7ec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57848f8b4b00f1ff2b7cb18ac3f66a23c05adbd239484ca6bcb1422dfded5f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3bd879ef932219be7bfe65b093e53f230203ee8bc45992c466db008621a320df"
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
