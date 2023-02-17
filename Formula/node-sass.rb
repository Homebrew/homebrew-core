class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.58.2.tgz"
  sha256 "a57366f8084fa4b41109ead6f3ede273d79b1627d4b4f676feca3a210aa27b78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c6038d647c8e195ee3406ff02570b998b6f760531fa1506cdfe85e64d5c4e9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c6038d647c8e195ee3406ff02570b998b6f760531fa1506cdfe85e64d5c4e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c6038d647c8e195ee3406ff02570b998b6f760531fa1506cdfe85e64d5c4e9b"
    sha256 cellar: :any_skip_relocation, ventura:        "3c6038d647c8e195ee3406ff02570b998b6f760531fa1506cdfe85e64d5c4e9b"
    sha256 cellar: :any_skip_relocation, monterey:       "3c6038d647c8e195ee3406ff02570b998b6f760531fa1506cdfe85e64d5c4e9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c6038d647c8e195ee3406ff02570b998b6f760531fa1506cdfe85e64d5c4e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0d3731598a3ce16f2546e9ffce686922c9b821f6849b9223ae77a9230bf59d"
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
