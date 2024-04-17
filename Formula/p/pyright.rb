require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.358.tgz"
  sha256 "845819ac100fbb5cd31e289d94a5ac5941717f7270a8e80fede745c98b4f7fab"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "924b9bbfc9e0b5e5056df78596fa1058fd15d55c0698113cfecb7394b93daf25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "924b9bbfc9e0b5e5056df78596fa1058fd15d55c0698113cfecb7394b93daf25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924b9bbfc9e0b5e5056df78596fa1058fd15d55c0698113cfecb7394b93daf25"
    sha256 cellar: :any_skip_relocation, sonoma:         "22ee179d481962ab621928a8c8f05b0f8378555f85da43cff31caeb137eac51a"
    sha256 cellar: :any_skip_relocation, ventura:        "22ee179d481962ab621928a8c8f05b0f8378555f85da43cff31caeb137eac51a"
    sha256 cellar: :any_skip_relocation, monterey:       "22ee179d481962ab621928a8c8f05b0f8378555f85da43cff31caeb137eac51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924b9bbfc9e0b5e5056df78596fa1058fd15d55c0698113cfecb7394b93daf25"
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
