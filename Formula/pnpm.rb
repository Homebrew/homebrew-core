class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.25.1.tgz"
  sha256 "58cc71d201039af75dd43d36f166e36da9843014e2c17d697b12c5c2662265fa"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a76aa6d7377da8aaf7a5c1f0f8d2eee3b68c393430423d6d8fcb9792efe9a49d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a76aa6d7377da8aaf7a5c1f0f8d2eee3b68c393430423d6d8fcb9792efe9a49d"
    sha256 cellar: :any_skip_relocation, monterey:       "dbf7427df5d4b2d7e7fd7f5e4323d7dc80e82a16283d94a0ff7a55347b6aaa02"
    sha256 cellar: :any_skip_relocation, big_sur:        "284c6aa8b22dd97735ada3f36538140c933a6f050f2ac5083aa36614397e947e"
    sha256 cellar: :any_skip_relocation, catalina:       "284c6aa8b22dd97735ada3f36538140c933a6f050f2ac5083aa36614397e947e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76aa6d7377da8aaf7a5c1f0f8d2eee3b68c393430423d6d8fcb9792efe9a49d"
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
