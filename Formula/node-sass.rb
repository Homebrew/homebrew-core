class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.52.0.tgz"
  sha256 "d72365abfb6162b0e0cd488a9c594131c43721b2f31e6611b50e1c9d8aef75ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5ba9d284ae5154187a1660d93f9454f56406c772364aaa32f67482f25f83aa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5ba9d284ae5154187a1660d93f9454f56406c772364aaa32f67482f25f83aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ba9d284ae5154187a1660d93f9454f56406c772364aaa32f67482f25f83aa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ba9d284ae5154187a1660d93f9454f56406c772364aaa32f67482f25f83aa8"
    sha256 cellar: :any_skip_relocation, catalina:       "e5ba9d284ae5154187a1660d93f9454f56406c772364aaa32f67482f25f83aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24943364e0208c36680b0c917009b8bf3b505076cfd527511df40e454d7ab9e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
