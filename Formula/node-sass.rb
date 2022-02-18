class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.49.8.tgz"
  sha256 "4a0a2bb23f5054c7e5b807f62442a86cb2dddb252f4e3aaa3b5741bdf85ecf6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e007d5cf5b64a19479d13f1a9016a81c6e7399ad5940523b24e9229298b94cc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e007d5cf5b64a19479d13f1a9016a81c6e7399ad5940523b24e9229298b94cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "e007d5cf5b64a19479d13f1a9016a81c6e7399ad5940523b24e9229298b94cc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e007d5cf5b64a19479d13f1a9016a81c6e7399ad5940523b24e9229298b94cc2"
    sha256 cellar: :any_skip_relocation, catalina:       "e007d5cf5b64a19479d13f1a9016a81c6e7399ad5940523b24e9229298b94cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ac1c15df89201e0a4e7cc81182554e900f2d1f66e2e21b7a6c6ecb5dee17bd"
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
