class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.58.0.tgz"
  sha256 "c00f1ec198da9923d1d071226e2fb3c761de2ce84dc554ef2cfe9627c43655bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e874d95db758e23f8a587797bd87fbc5294137f9461201be3a0da5e28e120746"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e874d95db758e23f8a587797bd87fbc5294137f9461201be3a0da5e28e120746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e874d95db758e23f8a587797bd87fbc5294137f9461201be3a0da5e28e120746"
    sha256 cellar: :any_skip_relocation, ventura:        "e874d95db758e23f8a587797bd87fbc5294137f9461201be3a0da5e28e120746"
    sha256 cellar: :any_skip_relocation, monterey:       "e874d95db758e23f8a587797bd87fbc5294137f9461201be3a0da5e28e120746"
    sha256 cellar: :any_skip_relocation, big_sur:        "e874d95db758e23f8a587797bd87fbc5294137f9461201be3a0da5e28e120746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ffe9c08db42a719d09bd474520d4cebd367076a66299e7d97a686d0a82e229e"
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
