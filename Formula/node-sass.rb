class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.6.tgz"
  sha256 "be55fa32f185d42a667a88d8f21516d98faab4d927bacdda82c823a21c07abb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315f5179a6a7b673a7313c67847677ae227e0c6ba8da3478084a32ffd5b3c276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "315f5179a6a7b673a7313c67847677ae227e0c6ba8da3478084a32ffd5b3c276"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "315f5179a6a7b673a7313c67847677ae227e0c6ba8da3478084a32ffd5b3c276"
    sha256 cellar: :any_skip_relocation, ventura:        "315f5179a6a7b673a7313c67847677ae227e0c6ba8da3478084a32ffd5b3c276"
    sha256 cellar: :any_skip_relocation, monterey:       "315f5179a6a7b673a7313c67847677ae227e0c6ba8da3478084a32ffd5b3c276"
    sha256 cellar: :any_skip_relocation, big_sur:        "315f5179a6a7b673a7313c67847677ae227e0c6ba8da3478084a32ffd5b3c276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a7c39658ca244bc135051c95662f95e32107320d79fa1a9bd671a5785897855"
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
