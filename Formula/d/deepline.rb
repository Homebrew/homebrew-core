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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fd20fe87d02b4e6de813f0ac1b98b9838a3881f4bf3bff185f9a865be472ab3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fd20fe87d02b4e6de813f0ac1b98b9838a3881f4bf3bff185f9a865be472ab3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fd20fe87d02b4e6de813f0ac1b98b9838a3881f4bf3bff185f9a865be472ab3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28af19fa5cffa618e9ada46d3446c0f6d2558ce5080e73c5a802602ba34cdfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dc3f0f747991e4177b1d99a3e1408ec0dcbc6c872001a4aaa6af7d323731896a"
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
