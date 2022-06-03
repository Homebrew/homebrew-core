class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.52.2.tgz"
  sha256 "4d54e11813d188e1b528b870c5b46fd77d9961fa11a284194dc2558fc80e8a34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b63625a468225a2721dc7675ae3ed1807bf27662eb5aec267ac5e47e2031bca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b63625a468225a2721dc7675ae3ed1807bf27662eb5aec267ac5e47e2031bca"
    sha256 cellar: :any_skip_relocation, monterey:       "4b63625a468225a2721dc7675ae3ed1807bf27662eb5aec267ac5e47e2031bca"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b63625a468225a2721dc7675ae3ed1807bf27662eb5aec267ac5e47e2031bca"
    sha256 cellar: :any_skip_relocation, catalina:       "4b63625a468225a2721dc7675ae3ed1807bf27662eb5aec267ac5e47e2031bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9337477af62f258ddc95d50e8716a99c35e2524e1231a50e86e4a08f1b2b87"
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
