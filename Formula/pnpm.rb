class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.23.1.tgz"
  sha256 "23d0121be9d06f9d30f091f9e6d41291374595826e1811477e4bb268e0a786d5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff2cf8700b419dbe31279bf60e1de8acd5114fdd3be69e3c7963dccb3968fcad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff2cf8700b419dbe31279bf60e1de8acd5114fdd3be69e3c7963dccb3968fcad"
    sha256 cellar: :any_skip_relocation, monterey:       "99ad7bed3144ef28823fb2821a2c5ce6f6207b742dc12b84ecfe36c28ab5d25f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6076d524ca51be726fdf6533fc11b09e5e282a351268be4d19457d7579db0f6d"
    sha256 cellar: :any_skip_relocation, catalina:       "6076d524ca51be726fdf6533fc11b09e5e282a351268be4d19457d7579db0f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2cf8700b419dbe31279bf60e1de8acd5114fdd3be69e3c7963dccb3968fcad"
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
