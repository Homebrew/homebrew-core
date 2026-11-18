class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.537.tgz"
  sha256 "916068ce87b193467cd06bfa539ca02549867a04e2a34096040f18a9638da990"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f48dcd1064db5bbb9c6631743907e983f662585f42a75b10e5c792c7023e0832"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f48dcd1064db5bbb9c6631743907e983f662585f42a75b10e5c792c7023e0832"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f48dcd1064db5bbb9c6631743907e983f662585f42a75b10e5c792c7023e0832"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a4553d1099feebcb6531d9c77ea0074e452987b2b153c8597add474b3bb44c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a691657824641ec065649df57c550f7a318839b73a57913f9e8b0d3e3f1e07f0"
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
