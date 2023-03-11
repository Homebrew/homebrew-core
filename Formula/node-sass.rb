class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.59.2.tgz"
  sha256 "e905f4af08bcc18ac9e28592591db4f9c696d98a0a85826a72bc6c3d62ddd53a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591486113c61e5158fc36449da590bbd0f5b6b0db9cecd2bb86b49fb579dc6e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591486113c61e5158fc36449da590bbd0f5b6b0db9cecd2bb86b49fb579dc6e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "591486113c61e5158fc36449da590bbd0f5b6b0db9cecd2bb86b49fb579dc6e5"
    sha256 cellar: :any_skip_relocation, ventura:        "591486113c61e5158fc36449da590bbd0f5b6b0db9cecd2bb86b49fb579dc6e5"
    sha256 cellar: :any_skip_relocation, monterey:       "591486113c61e5158fc36449da590bbd0f5b6b0db9cecd2bb86b49fb579dc6e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "591486113c61e5158fc36449da590bbd0f5b6b0db9cecd2bb86b49fb579dc6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc09134b51664c453bda40541aefe9d14badd90e53ef46e920bfebd9e1aed54d"
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
