require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.21.0.tgz"
  sha256 "8c58bb198ade38036467fe1ef7868ccd6f1da7c41aa300d0d446d895137c0a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9decacbd75c537b831ff079103122541f819e7cfa9f12d0738d8c82aa4e56b0" => :catalina
    sha256 "eb6c4c1ba702675ac146da87cada5d3579ad01e44f0cd7c9498e4d7809bdab5e" => :mojave
    sha256 "766dee25f8ad34b8a01f40a861b9f994b7e001dc2b0f7efd8b15c0c7c1e391a5" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
