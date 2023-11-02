require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.334.tgz"
  sha256 "6968f7c6ecd62d535cc510f8471ba1571b73947d0028325b2c31a1bf80452ac0"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42bfdeaaf849017d9950ab44942ba93d27402bba996d57bbe34592503660629b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42bfdeaaf849017d9950ab44942ba93d27402bba996d57bbe34592503660629b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42bfdeaaf849017d9950ab44942ba93d27402bba996d57bbe34592503660629b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4ba62ee7020105505f9a14b2d46104759fd043409c696a2bbf28b91b5def24b"
    sha256 cellar: :any_skip_relocation, ventura:        "e4ba62ee7020105505f9a14b2d46104759fd043409c696a2bbf28b91b5def24b"
    sha256 cellar: :any_skip_relocation, monterey:       "e4ba62ee7020105505f9a14b2d46104759fd043409c696a2bbf28b91b5def24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76d19ed1f1bf8556d3a4b174b1e6df240167e23770340ef6b219ff728ac32f4"
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
