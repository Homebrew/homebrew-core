class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.6.tgz"
  sha256 "488d1ec675d7e84b19678f466ee7cfa429a82a432399207825c4a98a16f29ba2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8b16969809a6386efe7759961ea17d5aab66d8d1e3b47caad18641558e9604"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e8b16969809a6386efe7759961ea17d5aab66d8d1e3b47caad18641558e9604"
    sha256 cellar: :any_skip_relocation, monterey:       "2d0fc0e08d16f7be9d455aa3b3e3548d78dd70fc96b4306571e5f342bedd3ae9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2328f08310d12c90199e0b3957b0b6b45a17c4b6e291edb7e1ea6f8da4b73901"
    sha256 cellar: :any_skip_relocation, catalina:       "2328f08310d12c90199e0b3957b0b6b45a17c4b6e291edb7e1ea6f8da4b73901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8b16969809a6386efe7759961ea17d5aab66d8d1e3b47caad18641558e9604"
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
