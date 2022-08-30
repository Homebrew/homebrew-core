class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.6.tgz"
  sha256 "95334a742b5c6922cc6549069dd4583a80a713a0baf52f88ab8804bc9a594bbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a29f887aeff0549010ccf091e698ef8020ace1dff272c905f4f9516a3e642f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7a29f887aeff0549010ccf091e698ef8020ace1dff272c905f4f9516a3e642f"
    sha256 cellar: :any_skip_relocation, monterey:       "c7a29f887aeff0549010ccf091e698ef8020ace1dff272c905f4f9516a3e642f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7a29f887aeff0549010ccf091e698ef8020ace1dff272c905f4f9516a3e642f"
    sha256 cellar: :any_skip_relocation, catalina:       "c7a29f887aeff0549010ccf091e698ef8020ace1dff272c905f4f9516a3e642f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca6801566764b516b31d4814e581c1a8157530071676e2c4a174fe0f875abf4"
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
