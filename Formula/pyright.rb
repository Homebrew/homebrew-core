require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.294.tgz"
  sha256 "752293bf19f3868ffa5ce926665706e8d9221b75acda7d687a4f0df37ea41534"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b55d882e7e77351faf750e01a8049db4a57092f17eb6868f75db3df50cf6d4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3ff31f3c526a8d4efd98a5279799e91f4764420c880287d7d881ff2c19360f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "179095f6a06ffca8200e2cda07ad271aec21c36466dc3407417da6ea78f17954"
    sha256 cellar: :any_skip_relocation, ventura:        "b141d462a152b4a591e1b141b3fd08e4d8afedd4d1351a2a7c45bbb9650d1642"
    sha256 cellar: :any_skip_relocation, monterey:       "23ee031394d4b8ee2daf6976eb7e5c3d70786bb69261295b44f2e372e6a26418"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e0085b1f345a40d058769e61e92ff25d8516f5d15b1da5a22f97f6334057cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c716c79049e35343199eb1cee4af88ed8ada9b33d74937a2c9aef1980fb40ab3"
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
