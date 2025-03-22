class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.2.1.tgz"
  sha256 "f15773dc6cf8ac484bf2ecff19407eed74d09b37f23462ae39f3b9d332abfeae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0b88bcb5230eadf32f3deaf38313a847ac7294064195570895c1d6d3fe13138"
    sha256 cellar: :any,                 arm64_sonoma:  "a0b88bcb5230eadf32f3deaf38313a847ac7294064195570895c1d6d3fe13138"
    sha256 cellar: :any,                 arm64_ventura: "a0b88bcb5230eadf32f3deaf38313a847ac7294064195570895c1d6d3fe13138"
    sha256 cellar: :any,                 sonoma:        "2c8eb0901262780fc977daaaf4ccd26a74d1c3af5fa48ca61f81ddadcaa28631"
    sha256 cellar: :any,                 ventura:       "2c8eb0901262780fc977daaaf4ccd26a74d1c3af5fa48ca61f81ddadcaa28631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "228276c35fe4f4615481d77aef303315780e1973ea60d172a11f59b7df631ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db2c35e406dd9e9bd6e484ec4d71351b9de278a2b7cfc0f8eee2c8a98465ed83"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
