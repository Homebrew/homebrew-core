class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.49.7.tgz"
  sha256 "4f41378bb578d02829a1a53b8056b2dc759e9dbd2caa9bf64583062a7af95210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3086724d3529229de07995a628e0d5a343d89917af7d2e2f94d54925475073e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3086724d3529229de07995a628e0d5a343d89917af7d2e2f94d54925475073e6"
    sha256 cellar: :any_skip_relocation, monterey:       "3086724d3529229de07995a628e0d5a343d89917af7d2e2f94d54925475073e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3086724d3529229de07995a628e0d5a343d89917af7d2e2f94d54925475073e6"
    sha256 cellar: :any_skip_relocation, catalina:       "3086724d3529229de07995a628e0d5a343d89917af7d2e2f94d54925475073e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f949a20a1fd3e061f354e99106193f115bf3532e3e0844533804a9470b0757a"
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
