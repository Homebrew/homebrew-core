class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.40.0.tgz"
  sha256 "d94b46e4010a254ee000ff6e6e5eb814cd6f5a1064f1f715962c508d58914eca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39d5459ba4485709c7a4259ac4d173e5a5dacf5557df79047dfcbf59b6152c92"
    sha256 cellar: :any_skip_relocation, big_sur:       "39d5459ba4485709c7a4259ac4d173e5a5dacf5557df79047dfcbf59b6152c92"
    sha256 cellar: :any_skip_relocation, catalina:      "39d5459ba4485709c7a4259ac4d173e5a5dacf5557df79047dfcbf59b6152c92"
    sha256 cellar: :any_skip_relocation, mojave:        "39d5459ba4485709c7a4259ac4d173e5a5dacf5557df79047dfcbf59b6152c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75acb844b5c6d2c659c3a1568bec2b271dff5bd6463c35bfb613fb31dbf80687"
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
