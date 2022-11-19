require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-50.0.1.tgz"
  sha256 "b4abb72acba7c5801636cfea82b7a69562ef12f86819bdf2d6fbd189e5ae8b1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d35b4c8a58305360a32266850adff76701962951fada138568e184fe7ad4b9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d35b4c8a58305360a32266850adff76701962951fada138568e184fe7ad4b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d35b4c8a58305360a32266850adff76701962951fada138568e184fe7ad4b9f"
    sha256 cellar: :any_skip_relocation, ventura:        "feb5380635bc94c205bddd2f8ad3930333446c4357858baa1df7eb6e50663c30"
    sha256 cellar: :any_skip_relocation, monterey:       "f3b285e09cb0671206fb6f640c34ec19ac0978b5ed75445a1e9250ac2473bd1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b285e09cb0671206fb6f640c34ec19ac0978b5ed75445a1e9250ac2473bd1e"
    sha256 cellar: :any_skip_relocation, catalina:       "f3b285e09cb0671206fb6f640c34ec19ac0978b5ed75445a1e9250ac2473bd1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d35b4c8a58305360a32266850adff76701962951fada138568e184fe7ad4b9f"
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
