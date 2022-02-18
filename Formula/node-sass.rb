class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.49.8.tgz"
  sha256 "4a0a2bb23f5054c7e5b807f62442a86cb2dddb252f4e3aaa3b5741bdf85ecf6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a87801e8138924bfc0287cfef7ef49c8888ede2a284ea2573dadab4b54c8b0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a87801e8138924bfc0287cfef7ef49c8888ede2a284ea2573dadab4b54c8b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a87801e8138924bfc0287cfef7ef49c8888ede2a284ea2573dadab4b54c8b0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a87801e8138924bfc0287cfef7ef49c8888ede2a284ea2573dadab4b54c8b0e"
    sha256 cellar: :any_skip_relocation, catalina:       "8a87801e8138924bfc0287cfef7ef49c8888ede2a284ea2573dadab4b54c8b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87a76c6b1722509786a3a35a009ed94b1435cc3d43b26b1cfa80c54b0df6f02"
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
