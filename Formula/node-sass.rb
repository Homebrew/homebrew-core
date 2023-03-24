class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.60.0.tgz"
  sha256 "dc3e121be72a6b3c47f4c3eb3c83c631c1a8f0e0d9d161ae68084d823e417123"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6d614f5684c5c71f0706e04e20a5c7fbbba613bc6c42c7c28d38ce0be9cea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e6d614f5684c5c71f0706e04e20a5c7fbbba613bc6c42c7c28d38ce0be9cea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e6d614f5684c5c71f0706e04e20a5c7fbbba613bc6c42c7c28d38ce0be9cea8"
    sha256 cellar: :any_skip_relocation, ventura:        "2e6d614f5684c5c71f0706e04e20a5c7fbbba613bc6c42c7c28d38ce0be9cea8"
    sha256 cellar: :any_skip_relocation, monterey:       "2e6d614f5684c5c71f0706e04e20a5c7fbbba613bc6c42c7c28d38ce0be9cea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6d614f5684c5c71f0706e04e20a5c7fbbba613bc6c42c7c28d38ce0be9cea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93925cd09c90923d53a7816374715c31b602705ffb1ee402c6637cab0b9d6d8b"
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
