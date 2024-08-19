class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.376.tgz"
  sha256 "4e6c6c8e4e97eeb489c99951c98adf233328e7ce11181188b184e1f8c2f25c8f"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06d84cb680fa566272130340e72c7a05d690e98d5dc5b3c5468c220d400262f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06d84cb680fa566272130340e72c7a05d690e98d5dc5b3c5468c220d400262f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06d84cb680fa566272130340e72c7a05d690e98d5dc5b3c5468c220d400262f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "27276bd8caf61c325f22fb46f57e2432be9446b63ebd91c6054804014cbbfb1c"
    sha256 cellar: :any_skip_relocation, ventura:        "27276bd8caf61c325f22fb46f57e2432be9446b63ebd91c6054804014cbbfb1c"
    sha256 cellar: :any_skip_relocation, monterey:       "27276bd8caf61c325f22fb46f57e2432be9446b63ebd91c6054804014cbbfb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d84cb680fa566272130340e72c7a05d690e98d5dc5b3c5468c220d400262f5"
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
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
