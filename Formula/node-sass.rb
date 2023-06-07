class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.2.tgz"
  sha256 "bedf074b6cc6c124690722f697ea4d89d2213341436c08c28f1860e2034bad40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7910b601cf7929147fbf0bfb31c13c8e231b58338f29a0b421df1a9d014550d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7910b601cf7929147fbf0bfb31c13c8e231b58338f29a0b421df1a9d014550d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7910b601cf7929147fbf0bfb31c13c8e231b58338f29a0b421df1a9d014550d"
    sha256 cellar: :any_skip_relocation, ventura:        "f7910b601cf7929147fbf0bfb31c13c8e231b58338f29a0b421df1a9d014550d"
    sha256 cellar: :any_skip_relocation, monterey:       "f7910b601cf7929147fbf0bfb31c13c8e231b58338f29a0b421df1a9d014550d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7910b601cf7929147fbf0bfb31c13c8e231b58338f29a0b421df1a9d014550d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80381de9386b1ac9a5ae05016617b2d6a76a01fc26f6e55673bb565865af1f1d"
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
