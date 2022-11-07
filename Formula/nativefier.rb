require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-50.0.1.tgz"
  sha256 "b4abb72acba7c5801636cfea82b7a69562ef12f86819bdf2d6fbd189e5ae8b1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87315c51ca37b9fe2b36375bfb20f66905ca97fa0738b5ebefce6449421c0a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d52bdaf1fd37f462fa937fe8e59368deec26d69a2cd7e055cd53387611dd6886"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d52bdaf1fd37f462fa937fe8e59368deec26d69a2cd7e055cd53387611dd6886"
    sha256 cellar: :any_skip_relocation, monterey:       "8d4e96702888dc4785f8aa32f04796ccc95d95f822286cc1b665ce5ea309f031"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d4e96702888dc4785f8aa32f04796ccc95d95f822286cc1b665ce5ea309f031"
    sha256 cellar: :any_skip_relocation, catalina:       "8d4e96702888dc4785f8aa32f04796ccc95d95f822286cc1b665ce5ea309f031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52bdaf1fd37f462fa937fe8e59368deec26d69a2cd7e055cd53387611dd6886"
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
