class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.49.11.tgz"
  sha256 "d7fd4fabac0e347f992821f02cea5aa702f59026a0f161893c05b41553d34e4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f6fc67dab59239c66508b253da250087231cdb8b3504ac8770b8b0e0e27134"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84f6fc67dab59239c66508b253da250087231cdb8b3504ac8770b8b0e0e27134"
    sha256 cellar: :any_skip_relocation, monterey:       "84f6fc67dab59239c66508b253da250087231cdb8b3504ac8770b8b0e0e27134"
    sha256 cellar: :any_skip_relocation, big_sur:        "84f6fc67dab59239c66508b253da250087231cdb8b3504ac8770b8b0e0e27134"
    sha256 cellar: :any_skip_relocation, catalina:       "84f6fc67dab59239c66508b253da250087231cdb8b3504ac8770b8b0e0e27134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763336a8cd3bf473a0eec5824cf73b54244c37930c1fa7d8b35fd152ee2c5209"
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
