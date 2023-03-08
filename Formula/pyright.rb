require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.298.tgz"
  sha256 "f0ac95b4e97999b825df6050d3dc34515faac6e9d206c30c9e7344ad182db325"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af23223e556d969ea02c4705518a9f7b4a3d8c0ccbfe0b68142b1c425b55b543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af23223e556d969ea02c4705518a9f7b4a3d8c0ccbfe0b68142b1c425b55b543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af23223e556d969ea02c4705518a9f7b4a3d8c0ccbfe0b68142b1c425b55b543"
    sha256 cellar: :any_skip_relocation, ventura:        "2e34bda43f52b6c9aefbbb2a82bb9d0aad0adc7c635d26a067c83ba77293b837"
    sha256 cellar: :any_skip_relocation, monterey:       "2e34bda43f52b6c9aefbbb2a82bb9d0aad0adc7c635d26a067c83ba77293b837"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e34bda43f52b6c9aefbbb2a82bb9d0aad0adc7c635d26a067c83ba77293b837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af23223e556d969ea02c4705518a9f7b4a3d8c0ccbfe0b68142b1c425b55b543"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
