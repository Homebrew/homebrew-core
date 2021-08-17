class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.38.0.tgz"
  sha256 "9a685cc635a57b816d24134ce622b6935e1e069291da7fc44195bed6b35dd2e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db11abbf031f6c33c30593a0cf426324ba636096275f26a1c98b80fd1a91d92e"
    sha256 cellar: :any_skip_relocation, big_sur:       "db11abbf031f6c33c30593a0cf426324ba636096275f26a1c98b80fd1a91d92e"
    sha256 cellar: :any_skip_relocation, catalina:      "db11abbf031f6c33c30593a0cf426324ba636096275f26a1c98b80fd1a91d92e"
    sha256 cellar: :any_skip_relocation, mojave:        "db11abbf031f6c33c30593a0cf426324ba636096275f26a1c98b80fd1a91d92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff1c6ac79beb1fa6cf7864bf71d62813feb57253687b403d88c1c935ccefc93"
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
