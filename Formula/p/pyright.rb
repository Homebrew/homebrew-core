class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.385.tgz"
  sha256 "4ccfe84c675c22878fe4592f90cdcf26ada4cdb96b846174eb7ecb32a7736677"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00b8a9468909a70228918fd5997ccca0705659a671de338418fb424de64b341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a00b8a9468909a70228918fd5997ccca0705659a671de338418fb424de64b341"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a00b8a9468909a70228918fd5997ccca0705659a671de338418fb424de64b341"
    sha256 cellar: :any_skip_relocation, sonoma:        "c75b1a9f4fa3d90a3603ae9970614220ebad29eafc7e25aed65790e2ece9082c"
    sha256 cellar: :any_skip_relocation, ventura:       "c75b1a9f4fa3d90a3603ae9970614220ebad29eafc7e25aed65790e2ece9082c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00b8a9468909a70228918fd5997ccca0705659a671de338418fb424de64b341"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
