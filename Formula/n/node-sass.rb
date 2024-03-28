class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.72.0.tgz"
  sha256 "0c3ab88974823e8cec1217d956a87b8b7e94980bf6dc7773b1f3936e45536d16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c1323667600c6d986ce3e38799627d46dea60d40239d573d76fe94e479facd0"
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
