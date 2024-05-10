require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.362.tgz"
  sha256 "9f06b92e2722208726c42e3bab5cd4885e33a26447cf322175246b6092ea4f7d"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9811f40d1705ee3bda66516773580ee6710072a813cc4dbf3c12c70651bbd30f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6d4bb67deb383633cff5df8603f7a7a9de3a040dc52e6a20f23da254f3b92ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66ebc3e0737cec75b7bc56d203c3d3450b2c211dce081258f04e2b7366d8cdad"
    sha256 cellar: :any_skip_relocation, sonoma:         "2113a0d94c896bbb9004f56bc733b9dd6b67d6cfa440017be997f23a04365127"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7ba823f0f7e806d4658fc0a741f2c8f938705815ec76386397549007db917e"
    sha256 cellar: :any_skip_relocation, monterey:       "314b222c47b1bf4e3c05130a10fd6d1da25da1cc3a632f5b8769b3a2d131f459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a55597b6a9db8dab8694f1b7fb865c392bf26453917b6f3d3c09204a9f5f44f9"
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
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
