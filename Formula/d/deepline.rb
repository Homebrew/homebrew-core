class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.535.tgz"
  sha256 "4322952a70f7adf1255076f25c8ede6ea6fad4dcc07f8f30f5b4b697f15fc1b2"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b1dfcaf45a630fb67ad60a902bbb7747be3fc1b5a492135c3c3230701bf8825"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b1dfcaf45a630fb67ad60a902bbb7747be3fc1b5a492135c3c3230701bf8825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b1dfcaf45a630fb67ad60a902bbb7747be3fc1b5a492135c3c3230701bf8825"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "952a4a16fd3e49db409106a7168cc90715689035d99b3dd8f722958fc449f9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ed3874c42d8f329aba0af62bd4420e2281ffea51325e04364b7082461d161020"
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
