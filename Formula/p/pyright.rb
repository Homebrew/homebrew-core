class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.399.tgz"
  sha256 "653574de459ffb3884d5aa0002c5436cfb59d9fc59adbe40123591d6eb1cf05d"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa5d73d2384e50d36431e092a6ae46acb40c390deda527a7244a4a2dc869e03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa5d73d2384e50d36431e092a6ae46acb40c390deda527a7244a4a2dc869e03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa5d73d2384e50d36431e092a6ae46acb40c390deda527a7244a4a2dc869e03a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5a5c95da0f425f759eb699f9911e06ef80222f67cf0a5f579e9247e129b2b0"
    sha256 cellar: :any_skip_relocation, ventura:       "9e5a5c95da0f425f759eb699f9911e06ef80222f67cf0a5f579e9247e129b2b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa5d73d2384e50d36431e092a6ae46acb40c390deda527a7244a4a2dc869e03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5d73d2384e50d36431e092a6ae46acb40c390deda527a7244a4a2dc869e03a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
