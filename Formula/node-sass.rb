class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.47.0.tgz"
  sha256 "98a048152c1da3bb3351f6fe526a0d0dc0913789d8d24a9fb70a00089f645097"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "723497e004f8f78e88e503e52560497301356a3315c1589b2695e1e79c58c23c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "723497e004f8f78e88e503e52560497301356a3315c1589b2695e1e79c58c23c"
    sha256 cellar: :any_skip_relocation, monterey:       "723497e004f8f78e88e503e52560497301356a3315c1589b2695e1e79c58c23c"
    sha256 cellar: :any_skip_relocation, big_sur:        "723497e004f8f78e88e503e52560497301356a3315c1589b2695e1e79c58c23c"
    sha256 cellar: :any_skip_relocation, catalina:       "723497e004f8f78e88e503e52560497301356a3315c1589b2695e1e79c58c23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75c17fcd8f7c78e6942d701ba3de85f91c9ef4500c40e5fa52502a02eed9951"
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
