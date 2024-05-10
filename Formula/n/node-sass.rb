class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.0.tgz"
  sha256 "cdd2856743c06ca99db2f149a154ed3ecc65bbf16f5bbb40f7ac624f64e98fdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5096154909cd1e33f1703d480b5ecefc198086e5d69d73b23e61456d0ecd0f41"
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
