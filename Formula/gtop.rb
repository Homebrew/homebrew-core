require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.2.tgz"
  sha256 "04fa0e7d72c07c863258d802d1fd1fbb421ea7ec9130d69dc079be8771c621fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e1cfda9baa709426b950da12369483bdd63afa7bc31b00ab382660157305db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62e1cfda9baa709426b950da12369483bdd63afa7bc31b00ab382660157305db"
    sha256 cellar: :any_skip_relocation, monterey:       "a633415a5e0edc11eb726d0c525be5f6645f4b3d2f73cad4f0e44f378db9d70a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a633415a5e0edc11eb726d0c525be5f6645f4b3d2f73cad4f0e44f378db9d70a"
    sha256 cellar: :any_skip_relocation, catalina:       "a633415a5e0edc11eb726d0c525be5f6645f4b3d2f73cad4f0e44f378db9d70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e1cfda9baa709426b950da12369483bdd63afa7bc31b00ab382660157305db"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "Error: Width must be multiple of 2", shell_output(bin/"gtop 2>&1", 1)
  end
end
