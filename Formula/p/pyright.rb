require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.354.tgz"
  sha256 "482beb1780a0311da689049f956660ff47b24c8d3ac34b09fa970deaf4f33082"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b5fbd005643647345ea373a2298cfaa6aa82bb78b07aa961089fb76bf5951fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b5fbd005643647345ea373a2298cfaa6aa82bb78b07aa961089fb76bf5951fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5fbd005643647345ea373a2298cfaa6aa82bb78b07aa961089fb76bf5951fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "de249214127386d3eb7e6286ce51124d04530f66fe721d3cc60e13cc67bd8cdd"
    sha256 cellar: :any_skip_relocation, ventura:        "de249214127386d3eb7e6286ce51124d04530f66fe721d3cc60e13cc67bd8cdd"
    sha256 cellar: :any_skip_relocation, monterey:       "de249214127386d3eb7e6286ce51124d04530f66fe721d3cc60e13cc67bd8cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b5fbd005643647345ea373a2298cfaa6aa82bb78b07aa961089fb76bf5951fc"
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
