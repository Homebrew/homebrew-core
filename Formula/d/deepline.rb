class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.266.tgz"
  sha256 "f11e9b78106858b6082eef3f26baedb084e2c37736144c3556d715c789a22961"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a44043854b3126a70486934b14585cdacb6c9d3a8fa0b1e7757bbe53b85391b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a44043854b3126a70486934b14585cdacb6c9d3a8fa0b1e7757bbe53b85391b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a44043854b3126a70486934b14585cdacb6c9d3a8fa0b1e7757bbe53b85391b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a360f15ab2c78a0b8161a923e858520e154e765f72ac5436a4af8dce2dfaac90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe0d97537fb45f27f4a9994c1ff8497f91394444556883017f90f7a7e0db9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a2a74b58b9589db6f33158267275db1bdb9dd469b1d9562b6257f39ed80df8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
