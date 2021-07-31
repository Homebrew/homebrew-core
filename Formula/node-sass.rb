class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.37.0.tgz"
  sha256 "385e6789adf9561e3e7c9d0ec10b818cb528ebf1bd7205f73692fd6320a2ca9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, big_sur:       "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, catalina:      "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, mojave:        "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af28f19c2171e8090399f3afd5c8cb743913221be58f308867e8707e579817e"
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
