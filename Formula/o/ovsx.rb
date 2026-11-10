class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.4.0.tgz"
  sha256 "0613791261483819ce3d2944219f8639e91aa4f6b639294d2aa9f8bbced2634e"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "49322d118b873d4b950b319122594f814eae8400314c99b10f2a5ac8565b2bc2"
    sha256 cellar: :any, arm64_tahoe:       "49322d118b873d4b950b319122594f814eae8400314c99b10f2a5ac8565b2bc2"
    sha256 cellar: :any, arm64_sequoia:     "49322d118b873d4b950b319122594f814eae8400314c99b10f2a5ac8565b2bc2"
    sha256 cellar: :any, arm64_linux:       "0b323c33fe001753d550eefe9a63b7252ab43da251ca0173ed58fccfea1219a8"
    sha256 cellar: :any, x86_64_linux:      "42d697c66c0fe3627466813cb8f0bbc51ea3a87353ab717734da9b2504ef12e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
