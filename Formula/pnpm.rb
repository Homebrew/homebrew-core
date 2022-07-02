class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.5.0.tgz"
  sha256 "5e7a6eecd21e3b2562de049f5c6f26ddd2cd2c42e939f0ed84cf9377d3acd1e1"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a24275f10fc80fc7d21d1d8b6c2d08231b79cfa9f540910954d3a28f12fbe4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a24275f10fc80fc7d21d1d8b6c2d08231b79cfa9f540910954d3a28f12fbe4a"
    sha256 cellar: :any_skip_relocation, monterey:       "2d5adefa2d4e3a4440c3fb0d042a4073a534f5309de5d3b1049419a031a81989"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d1eb7b76009617cd157e9f945c4fd04b51536a3ecf60b871e780376ece75c08"
    sha256 cellar: :any_skip_relocation, catalina:       "2d1eb7b76009617cd157e9f945c4fd04b51536a3ecf60b871e780376ece75c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a24275f10fc80fc7d21d1d8b6c2d08231b79cfa9f540910954d3a28f12fbe4a"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
