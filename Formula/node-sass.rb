class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.29.0.tgz"
  sha256 "ab8c7ecbc4cec8a6709d1edabf6cd6679b0a870ee5a00d116ad8f708cf897823"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "128e5df1b7b0b29c8c21f7256b65f672e03f5f83cbc576656c87d076c97d52e8" => :catalina
    sha256 "8f46df78c60188b9c23d38c5e967ee009e3a3fe5ac15a0c8f072b4878c0134fc" => :mojave
    sha256 "e1ba29995caf1df38d12c34962ff8641eda44ac492ec88ec30bf377ace4b6fa6" => :high_sierra
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
