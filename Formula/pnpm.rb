class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.20.4.tgz"
  sha256 "36cc351673f530017654ccc89265b522967fd364b6ba3301193005e08469b962"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bb8ff409344b38cdbf08291a63cace24bb5d4de81f1b4eee01a64815dc6028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0bb8ff409344b38cdbf08291a63cace24bb5d4de81f1b4eee01a64815dc6028"
    sha256 cellar: :any_skip_relocation, monterey:       "77d2cf671c5b7f00797f7d2970a6b29cc1d77b7d7938c31076ec058c013797a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1961b699743b7e7eb593b3aefc3bc43c356238638f15b227b9bf641e4f2a7b9"
    sha256 cellar: :any_skip_relocation, catalina:       "d1961b699743b7e7eb593b3aefc3bc43c356238638f15b227b9bf641e4f2a7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0bb8ff409344b38cdbf08291a63cace24bb5d4de81f1b4eee01a64815dc6028"
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
