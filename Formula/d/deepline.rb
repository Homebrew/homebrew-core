class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.553.tgz"
  sha256 "ed0605764793084779684c1828ee0168c8e270f578ffd7e78e19452469c4a423"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "816f29843c3f5da5e21c6247bbb9f4d508717363281f7bb956751b30ecb3918e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f23375e41bc0e03b781d33d3ed26fe9ea91b3553613375bb42c1f6a5f806e1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f23375e41bc0e03b781d33d3ed26fe9ea91b3553613375bb42c1f6a5f806e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f23375e41bc0e03b781d33d3ed26fe9ea91b3553613375bb42c1f6a5f806e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "476a00359fed9168b918ff96236bdd8bd2dc4d9451773ac8b2760e8c311fc286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2e4f2739fa197959614fe6c9b6d49c5e69729b50c0ca970dd567ea32e4a542fb"
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
