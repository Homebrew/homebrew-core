class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.551.tgz"
  sha256 "44105efbed6bd7e2cd42401b79f25e5d586ed71d6b01c90df82b31cc25d27f71"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5c93d35479ddd11b9f15034a36698e719be21676053ad5f02bd18a617a244fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5c93d35479ddd11b9f15034a36698e719be21676053ad5f02bd18a617a244fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5c93d35479ddd11b9f15034a36698e719be21676053ad5f02bd18a617a244fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "daf9a5b8e8b2a6cce3d09b83d91c7c9cc9e2bce68595a92d86f541badcd4a3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b2b82a52a61e766b71d542a5983d46091554596c397db1c309e2e42813517c3b"
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
