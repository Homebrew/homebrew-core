require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.294.tgz"
  sha256 "752293bf19f3868ffa5ce926665706e8d9221b75acda7d687a4f0df37ea41534"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "901d84ec68736fe70a95b8a817ec3ce28667576bd0a6ae7faf237bb37637848a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "901d84ec68736fe70a95b8a817ec3ce28667576bd0a6ae7faf237bb37637848a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "901d84ec68736fe70a95b8a817ec3ce28667576bd0a6ae7faf237bb37637848a"
    sha256 cellar: :any_skip_relocation, ventura:        "48b232ab978e17630f9946078c3d00ffb5cdb2fdf41207257b4407c45da3bf0f"
    sha256 cellar: :any_skip_relocation, monterey:       "48b232ab978e17630f9946078c3d00ffb5cdb2fdf41207257b4407c45da3bf0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b232ab978e17630f9946078c3d00ffb5cdb2fdf41207257b4407c45da3bf0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "901d84ec68736fe70a95b8a817ec3ce28667576bd0a6ae7faf237bb37637848a"
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
