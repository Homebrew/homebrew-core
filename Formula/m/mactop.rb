class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "67e18a66fdad76c2c94fab20996f7ccd7864e774dae92bb0c6cc38a94daa2e74"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f68ac96081d9b68a4749a58f2fa3629c82762d909829fdeef0883a8682ba647f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf457c63ffc8a6338cdebed20d86772c61658fd268922794413f8d398b4505a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67df5d4f43316c0543d192884f654e5171bde700b974c096e18a00b131730a25"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
