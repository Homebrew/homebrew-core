class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.46.0.tgz"
  sha256 "7f693bbe00f55b8829ded587b94f4f2713c42bc85b8793c2569866a6f9670bd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa933c62f0f026990487701463493bbbf7686be9a1c2c24c50cc2da638b85919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa933c62f0f026990487701463493bbbf7686be9a1c2c24c50cc2da638b85919"
    sha256 cellar: :any_skip_relocation, monterey:       "aa933c62f0f026990487701463493bbbf7686be9a1c2c24c50cc2da638b85919"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa933c62f0f026990487701463493bbbf7686be9a1c2c24c50cc2da638b85919"
    sha256 cellar: :any_skip_relocation, catalina:       "aa933c62f0f026990487701463493bbbf7686be9a1c2c24c50cc2da638b85919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e919c27b21a626986abbdaa14134eac566de9b4a876764bb5d226e2090f3282"
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
