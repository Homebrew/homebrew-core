class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.3.tgz"
  sha256 "8a1f56162e733959e5367864130429df2a8075749a4e241d8c910010767f7f00"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab9de07a56b136e8fbad24b840a1526d90889e08fcb820f0e04cab12c1944e88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab9de07a56b136e8fbad24b840a1526d90889e08fcb820f0e04cab12c1944e88"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ee6be399883df20c3fe8edacd319d6823211e140214dac40183c7a6a6a7775"
    sha256 cellar: :any_skip_relocation, big_sur:        "cce90e739b6c9a02e9112c6043f29a084b084ad5037c877dc0607385ba77608a"
    sha256 cellar: :any_skip_relocation, catalina:       "cce90e739b6c9a02e9112c6043f29a084b084ad5037c877dc0607385ba77608a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab9de07a56b136e8fbad24b840a1526d90889e08fcb820f0e04cab12c1944e88"
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
