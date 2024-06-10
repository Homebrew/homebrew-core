require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.3.1.tgz"
  sha256 "af1a4838577a569b1e67b1b2788645ab7974ee82a443e9524b3c0fc1536c2093"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98a924f398fc9445d789eaeb81079b4b9542b4497866eec69b9defab608d6839"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98a924f398fc9445d789eaeb81079b4b9542b4497866eec69b9defab608d6839"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98a924f398fc9445d789eaeb81079b4b9542b4497866eec69b9defab608d6839"
    sha256 cellar: :any_skip_relocation, sonoma:         "98a924f398fc9445d789eaeb81079b4b9542b4497866eec69b9defab608d6839"
    sha256 cellar: :any_skip_relocation, ventura:        "98a924f398fc9445d789eaeb81079b4b9542b4497866eec69b9defab608d6839"
    sha256 cellar: :any_skip_relocation, monterey:       "98a924f398fc9445d789eaeb81079b4b9542b4497866eec69b9defab608d6839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037092a9d85f7bf0332b58420846bb0cb9079f2edcd70678bed0fa1647f0ee2b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
