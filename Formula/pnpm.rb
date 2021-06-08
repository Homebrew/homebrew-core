class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.3.tgz"
  sha256 "dff9f8b354a0ea4c2d89d23bafb30b75202519838d71f5205c800254b3769e7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bdd58b55f931affd90e176c8dcc57939ef94b0576934ec07a40c76d6fc60b91"
    sha256 cellar: :any_skip_relocation, big_sur:       "df998f0b916fe1cc01f992426a90b4ed2011349e223b6bd1712b87eeb8c45ccc"
    sha256 cellar: :any_skip_relocation, catalina:      "df998f0b916fe1cc01f992426a90b4ed2011349e223b6bd1712b87eeb8c45ccc"
    sha256 cellar: :any_skip_relocation, mojave:        "df998f0b916fe1cc01f992426a90b4ed2011349e223b6bd1712b87eeb8c45ccc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
