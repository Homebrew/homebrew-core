class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.401.tgz"
  sha256 "314aee741763f9c120da6f4c08352ba15fe161142193a68b9e04108a139a3d0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7108522532491ded273b23a95c4c20c4aac0f6dbf3d0e4e59c7d49c73b7d512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7108522532491ded273b23a95c4c20c4aac0f6dbf3d0e4e59c7d49c73b7d512"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7108522532491ded273b23a95c4c20c4aac0f6dbf3d0e4e59c7d49c73b7d512"
    sha256 cellar: :any_skip_relocation, sonoma:        "b63d5a57d2f9315ac6960ef32e0122c25b475261c26ff22d7ed3127b3cab7b4f"
    sha256 cellar: :any_skip_relocation, ventura:       "b63d5a57d2f9315ac6960ef32e0122c25b475261c26ff22d7ed3127b3cab7b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7108522532491ded273b23a95c4c20c4aac0f6dbf3d0e4e59c7d49c73b7d512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7108522532491ded273b23a95c4c20c4aac0f6dbf3d0e4e59c7d49c73b7d512"
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
