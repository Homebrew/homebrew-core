class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.393.tgz"
  sha256 "8b18e165f045ce90bac365fc6730242c136add74a409dcd09c534efe2a5062a2"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee3081c6130b0632cc287a8fecf93471cd8f45db2cb4ce27a40181689868e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ee3081c6130b0632cc287a8fecf93471cd8f45db2cb4ce27a40181689868e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ee3081c6130b0632cc287a8fecf93471cd8f45db2cb4ce27a40181689868e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "610673db7629e8d8aee164bf285b3d02b3ab10ac5d115ddb867e60b363c30116"
    sha256 cellar: :any_skip_relocation, ventura:       "610673db7629e8d8aee164bf285b3d02b3ab10ac5d115ddb867e60b363c30116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee3081c6130b0632cc287a8fecf93471cd8f45db2cb4ce27a40181689868e2d"
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
