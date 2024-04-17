class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.75.0.tgz"
  sha256 "ccc78004176c0cf431d98553920d3df4e8e97aa5e2b35c04691f9f770b44ba83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "704120006840ec3cb01e923935918da23b78ba3272e9c2c81efb1e78093f88bc"
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
