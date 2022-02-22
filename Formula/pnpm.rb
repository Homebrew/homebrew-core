class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.0.tgz"
  sha256 "f2d630e3b1a55d32813b47d5a0746bf36ca94aa56cb87d10977d8e3cae5adee4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4cd6dcea68b1c8482362cbb0efa224d93fbea8b7741f1bdf386c1c86821fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd4cd6dcea68b1c8482362cbb0efa224d93fbea8b7741f1bdf386c1c86821fbc"
    sha256 cellar: :any_skip_relocation, monterey:       "cdeb081e573f681a7cdfe5db14a3f7eb14ac8930e358424821ecfc14be73d74b"
    sha256 cellar: :any_skip_relocation, big_sur:        "69929c6a88224d8160ed9a85df1a150c658359dccfabfea8f278fa34e6a43aed"
    sha256 cellar: :any_skip_relocation, catalina:       "69929c6a88224d8160ed9a85df1a150c658359dccfabfea8f278fa34e6a43aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4cd6dcea68b1c8482362cbb0efa224d93fbea8b7741f1bdf386c1c86821fbc"
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
