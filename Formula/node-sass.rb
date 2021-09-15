class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.41.0.tgz"
  sha256 "0cbbc711545ad45de09e9cd3f9454adf8ecd81024db654fb348ddfd5d5f96ee8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60ddeb8a9127c55c26ce40fd634782931ef66e95e142639e5c3e317cd5a86438"
    sha256 cellar: :any_skip_relocation, big_sur:       "60ddeb8a9127c55c26ce40fd634782931ef66e95e142639e5c3e317cd5a86438"
    sha256 cellar: :any_skip_relocation, catalina:      "60ddeb8a9127c55c26ce40fd634782931ef66e95e142639e5c3e317cd5a86438"
    sha256 cellar: :any_skip_relocation, mojave:        "60ddeb8a9127c55c26ce40fd634782931ef66e95e142639e5c3e317cd5a86438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac927e354c4e08f1654c08c78c4696a3d14bfa07b358f46013fe141987ad900"
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
