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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d790c1b827cd9ee7b88a6fd36fba8d4b115ad9d449d632a58a03baecb0e998d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d790c1b827cd9ee7b88a6fd36fba8d4b115ad9d449d632a58a03baecb0e998d3"
    sha256 cellar: :any_skip_relocation, monterey:       "88e429a5908ca432a2ff1e8030c7904f3160bb4a7fcc943b5837422a3daa916b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e547bae308b54b64c580e1e5d9e27cba6071b7645fe5c44dfd728f3132d5115e"
    sha256 cellar: :any_skip_relocation, catalina:       "e547bae308b54b64c580e1e5d9e27cba6071b7645fe5c44dfd728f3132d5115e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d790c1b827cd9ee7b88a6fd36fba8d4b115ad9d449d632a58a03baecb0e998d3"
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
