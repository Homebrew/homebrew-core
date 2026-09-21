class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.68.0.tgz"
  sha256 "bf2309e391725080c15667971677d8d73bfe4cce7cdea4854c70814a4ccec19c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7ea822dfa5e3f4e9123b99a5f1e55429cb10eb9978354a918540f041ca825045"
    sha256 cellar: :any,                 arm64_tahoe:       "7ea822dfa5e3f4e9123b99a5f1e55429cb10eb9978354a918540f041ca825045"
    sha256 cellar: :any,                 arm64_sequoia:     "7ea822dfa5e3f4e9123b99a5f1e55429cb10eb9978354a918540f041ca825045"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "840bd3ba31ce6ec259ac62472f9cc22cb0be559ad6664024044a62b3cfce2e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "391ddc15f4c7bfd92b5843f4aa79f70fc2020f9cd453b68f3bdc1d4de0ed43c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end
