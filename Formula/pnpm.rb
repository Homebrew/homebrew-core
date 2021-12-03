class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.23.5.tgz"
  sha256 "7c9b0c76c1df2301b665a0c5ce068666ede0cdd055ae0ad45b1e875ac57bf852"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ff75d1654e44b749a9778c40ff1770ee8ac8b1de10529e953454307990e882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97ff75d1654e44b749a9778c40ff1770ee8ac8b1de10529e953454307990e882"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab2ef41f52036f5209996073ebefedd2723993768b05852b27644c81b7fc4d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc29cb45150fbb0a463a909a3ae6927e4891407a45b4153f18f4afd4e3398db4"
    sha256 cellar: :any_skip_relocation, catalina:       "cc29cb45150fbb0a463a909a3ae6927e4891407a45b4153f18f4afd4e3398db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ff75d1654e44b749a9778c40ff1770ee8ac8b1de10529e953454307990e882"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
