class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.47.0.tgz"
  sha256 "98a048152c1da3bb3351f6fe526a0d0dc0913789d8d24a9fb70a00089f645097"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d04ff209dffb4f46cf49093cb751bf91a6d5de628142436b5b1f4215ce127876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d04ff209dffb4f46cf49093cb751bf91a6d5de628142436b5b1f4215ce127876"
    sha256 cellar: :any_skip_relocation, monterey:       "d04ff209dffb4f46cf49093cb751bf91a6d5de628142436b5b1f4215ce127876"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04ff209dffb4f46cf49093cb751bf91a6d5de628142436b5b1f4215ce127876"
    sha256 cellar: :any_skip_relocation, catalina:       "d04ff209dffb4f46cf49093cb751bf91a6d5de628142436b5b1f4215ce127876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f58dfe39206b0f157a586c1440be4d0217093aa0c3e4f75e96929ae27f28f1"
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
