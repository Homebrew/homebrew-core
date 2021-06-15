require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.3.tgz"
  sha256 "a356cdff1e350ea3d30c4d667b60b5af5f69e22456a33b66b8c3a393debc04ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a10757b77e49ab86151e7c2c42dc4b9a0b61013bd83f662efbb227a21becf88"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c2939f93d46faf73eb2763bb7a2d3076f0d17b4513b44ff677e2351fb49f7ba"
    sha256 cellar: :any_skip_relocation, catalina:      "5c2939f93d46faf73eb2763bb7a2d3076f0d17b4513b44ff677e2351fb49f7ba"
    sha256 cellar: :any_skip_relocation, mojave:        "5c2939f93d46faf73eb2763bb7a2d3076f0d17b4513b44ff677e2351fb49f7ba"
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
