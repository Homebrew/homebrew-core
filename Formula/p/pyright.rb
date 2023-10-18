require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.332.tgz"
  sha256 "5628637247f609406955d98cb06fa45bcfac4e59514cdaea23e07838f7150ffc"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c1e23608e5b8475bb51fd6cf63764141788a28b0de15572c4ec2f95e022f717"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c1e23608e5b8475bb51fd6cf63764141788a28b0de15572c4ec2f95e022f717"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c1e23608e5b8475bb51fd6cf63764141788a28b0de15572c4ec2f95e022f717"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffea1bdf73af7a3bba9b5354349e0f40e0c88c477a2dfa212f67d79db97e998a"
    sha256 cellar: :any_skip_relocation, ventura:        "ffea1bdf73af7a3bba9b5354349e0f40e0c88c477a2dfa212f67d79db97e998a"
    sha256 cellar: :any_skip_relocation, monterey:       "ffea1bdf73af7a3bba9b5354349e0f40e0c88c477a2dfa212f67d79db97e998a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a951713596a0df927c206e5d6cde209a1632a01f36a2157eb5af552f8cd58578"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
