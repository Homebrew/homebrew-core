require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.6.tgz"
  sha256 "9bf716cf75ca07b7bcf8005572af0ea695aa80fff0b4102c018da569eade420e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "037b4593b230c0f6a8502a8187c3606884241e65372c77a549197ee30015bf43"
    sha256 cellar: :any_skip_relocation, big_sur:       "b457041a8da12080de7897f57784ec81a041797dcc369c1c43fad637faef6e57"
    sha256 cellar: :any_skip_relocation, catalina:      "b457041a8da12080de7897f57784ec81a041797dcc369c1c43fad637faef6e57"
    sha256 cellar: :any_skip_relocation, mojave:        "b457041a8da12080de7897f57784ec81a041797dcc369c1c43fad637faef6e57"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
