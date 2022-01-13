class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.26.1.tgz"
  sha256 "3c43a6dce8ed04f77b234338fdfbaad993f0adb22c41ab78dd81bba8e0ea88d2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a6032d99d397cfad1f2acfc261efc7219ae5aa9cc84d570db5c1500ec4ddad8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a6032d99d397cfad1f2acfc261efc7219ae5aa9cc84d570db5c1500ec4ddad8"
    sha256 cellar: :any_skip_relocation, monterey:       "66d83a1fafe4ed2e6b387d69353599e0ee55211071d26b262e87211153dd1fb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "58a4aa325a2b11e2dead3f81781805e53bf41257fb77bbad796d6e7d0543fcee"
    sha256 cellar: :any_skip_relocation, catalina:       "58a4aa325a2b11e2dead3f81781805e53bf41257fb77bbad796d6e7d0543fcee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6032d99d397cfad1f2acfc261efc7219ae5aa9cc84d570db5c1500ec4ddad8"
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
