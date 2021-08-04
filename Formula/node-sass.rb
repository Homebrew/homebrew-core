class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.37.5.tgz"
  sha256 "2a9ed25b85628009ebb8f5f54df886d00b41536b1c2c69e38f70dc50a89314fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, big_sur:       "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, catalina:      "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, mojave:        "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d4ab76a30cd5c54772e34c8a6928f371912e58cb2d21fda654820a19668a7a"
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
