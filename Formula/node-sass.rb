class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.42.0.tgz"
  sha256 "48f585c6e6d04a5f4ae98080fa1847e7c408b49b034fc51811f8b7bc9c5a958c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45b8a7aa7417fc0fee50f4e190c33276082a905342988f1bde1bcd50464709ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "45b8a7aa7417fc0fee50f4e190c33276082a905342988f1bde1bcd50464709ae"
    sha256 cellar: :any_skip_relocation, catalina:      "45b8a7aa7417fc0fee50f4e190c33276082a905342988f1bde1bcd50464709ae"
    sha256 cellar: :any_skip_relocation, mojave:        "45b8a7aa7417fc0fee50f4e190c33276082a905342988f1bde1bcd50464709ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1f46ad7632f850b294a85acd54b32a00961b8833d8136a35756ab78d2784d2"
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
