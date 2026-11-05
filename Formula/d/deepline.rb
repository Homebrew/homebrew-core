class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.463.tgz"
  sha256 "c8aee97cd9e4a5f85ae39f45513e1c393240d47ca2f884b042dc38bc6a8bc60a"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25e2873f26da083bbc9432fd5c2c5bf434b02869379b35a475b138a6a3cc9424"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25e2873f26da083bbc9432fd5c2c5bf434b02869379b35a475b138a6a3cc9424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25e2873f26da083bbc9432fd5c2c5bf434b02869379b35a475b138a6a3cc9424"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1dff87230c1d344cc81d3d10b9c2657a52d9b009fcd70d36242ab62e22f3c847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2502b9da32b259d6b127a520e0fea74721a06844661e7e6809d2275b2352fbf1"
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
