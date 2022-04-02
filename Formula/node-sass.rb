class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.49.11.tgz"
  sha256 "d7fd4fabac0e347f992821f02cea5aa702f59026a0f161893c05b41553d34e4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4369e72bfdb93199aa994c8fe57e08a7b3cc98c4b4ae72fdd490b2054e6bb04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4369e72bfdb93199aa994c8fe57e08a7b3cc98c4b4ae72fdd490b2054e6bb04"
    sha256 cellar: :any_skip_relocation, monterey:       "a4369e72bfdb93199aa994c8fe57e08a7b3cc98c4b4ae72fdd490b2054e6bb04"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4369e72bfdb93199aa994c8fe57e08a7b3cc98c4b4ae72fdd490b2054e6bb04"
    sha256 cellar: :any_skip_relocation, catalina:       "a4369e72bfdb93199aa994c8fe57e08a7b3cc98c4b4ae72fdd490b2054e6bb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "098c38d2d9b98451fbe9623ff72e685431933fc7ce77eca629b7c0937ff8ab34"
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
