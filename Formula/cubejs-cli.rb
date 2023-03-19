require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.9.tgz"
  sha256 "80a270f195eed74e3e4f2604ccb1a157e2002fb738d73e04e92f80f25e51f7e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7448b86b6766da1f0aacb80078e57c5abbf2d45a8d0477bba34bab781836c807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7448b86b6766da1f0aacb80078e57c5abbf2d45a8d0477bba34bab781836c807"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7448b86b6766da1f0aacb80078e57c5abbf2d45a8d0477bba34bab781836c807"
    sha256 cellar: :any_skip_relocation, ventura:        "ab62c2b346d7daf3c38fe272bd1915929995041dd2feff4f25def627857d9e81"
    sha256 cellar: :any_skip_relocation, monterey:       "ab62c2b346d7daf3c38fe272bd1915929995041dd2feff4f25def627857d9e81"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab62c2b346d7daf3c38fe272bd1915929995041dd2feff4f25def627857d9e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7448b86b6766da1f0aacb80078e57c5abbf2d45a8d0477bba34bab781836c807"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
