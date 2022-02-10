class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.30.1.tgz"
  sha256 "568c6512208f31f58f9a23dd8130ab600444b03653d331ed4b7d29be9ff2ed4b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5879636fc31de5c5333b8ae5dc56bf45d258dac4435ea73d26a93b96e80fc12b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5879636fc31de5c5333b8ae5dc56bf45d258dac4435ea73d26a93b96e80fc12b"
    sha256 cellar: :any_skip_relocation, monterey:       "e495feb282f03942c1fd992003a233fffa92f471ef6c82ecb1627e07afb967c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c69e54afa41c61220d4dc16a08367530210a817f845ae0a335bf45ca18433e8"
    sha256 cellar: :any_skip_relocation, catalina:       "2c69e54afa41c61220d4dc16a08367530210a817f845ae0a335bf45ca18433e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5879636fc31de5c5333b8ae5dc56bf45d258dac4435ea73d26a93b96e80fc12b"
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
