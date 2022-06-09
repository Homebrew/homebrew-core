class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.52.3.tgz"
  sha256 "e064b7f3c8b0a7202c2d8ae5890a8a22cf243510f2fe0968a8e78b73150079f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cee1571846a8c6e13c81dfa178f56a6545814ee6112d90fd5b0025d0a8126956"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cee1571846a8c6e13c81dfa178f56a6545814ee6112d90fd5b0025d0a8126956"
    sha256 cellar: :any_skip_relocation, monterey:       "cee1571846a8c6e13c81dfa178f56a6545814ee6112d90fd5b0025d0a8126956"
    sha256 cellar: :any_skip_relocation, big_sur:        "cee1571846a8c6e13c81dfa178f56a6545814ee6112d90fd5b0025d0a8126956"
    sha256 cellar: :any_skip_relocation, catalina:       "cee1571846a8c6e13c81dfa178f56a6545814ee6112d90fd5b0025d0a8126956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c5567bf64bd8d54fb81cfa1bd5bce3888adecb9c935591cdc9c9b20b53c859"
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
