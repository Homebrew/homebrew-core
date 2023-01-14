require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.289.tgz"
  sha256 "b27975a8193748e355da4e7b97160e9eb200e06dc43ef6971ab1e1a298422794"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83024a90d04afacac817b9584ff4e3873346162860abdc216955d9105e17be06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83024a90d04afacac817b9584ff4e3873346162860abdc216955d9105e17be06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83024a90d04afacac817b9584ff4e3873346162860abdc216955d9105e17be06"
    sha256 cellar: :any_skip_relocation, ventura:        "928c7d5fac2782deeb61dd99e913a5f18d8afd8269965c6db2bab31488a9527a"
    sha256 cellar: :any_skip_relocation, monterey:       "928c7d5fac2782deeb61dd99e913a5f18d8afd8269965c6db2bab31488a9527a"
    sha256 cellar: :any_skip_relocation, big_sur:        "928c7d5fac2782deeb61dd99e913a5f18d8afd8269965c6db2bab31488a9527a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83024a90d04afacac817b9584ff4e3873346162860abdc216955d9105e17be06"
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
