class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.37.4.tgz"
  sha256 "e19ba8cfa6d5be088086ca79e22867d4ef5026033134da3a4c99de064bc82530"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, catalina:      "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, mojave:        "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2ca177f6f374faf3bc8737ac56e6ba58d77bcfd0a6149e77169cf4b490b4d4"
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
