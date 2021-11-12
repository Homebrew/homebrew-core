class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.21.1.tgz"
  sha256 "d1ebb11ce3d23550fca9152eab744d6e912b8843383940c2d4b9f2d121c86ad0"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb6229b341927b9af72abae4cc270e3a77965a526f56c621ad6ef57bde665eb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb6229b341927b9af72abae4cc270e3a77965a526f56c621ad6ef57bde665eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "26aefe3c41dffa14f9065497f0f4fb2289bbaf1c035367837a6290dc12f2c999"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4bc7afa3e317dc3d941e3dbaa6200681efbd6766df28ea290b53347eb6fdd08"
    sha256 cellar: :any_skip_relocation, catalina:       "d4bc7afa3e317dc3d941e3dbaa6200681efbd6766df28ea290b53347eb6fdd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6229b341927b9af72abae4cc270e3a77965a526f56c621ad6ef57bde665eb2"
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
