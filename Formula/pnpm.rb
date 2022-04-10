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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f6342f6edfdabdfd73eb44a07fc54688ef6ab03c9b45749ecc6447d61879f0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f6342f6edfdabdfd73eb44a07fc54688ef6ab03c9b45749ecc6447d61879f0e"
    sha256 cellar: :any_skip_relocation, monterey:       "d965b2e77543f57cdb8767169529fce5d5319794c7035503d71e46afd6bced0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "81dc5dedf40a8bbb9c1a2b92483b62fa0e6f6543f79f6a7bfb77be1912a91006"
    sha256 cellar: :any_skip_relocation, catalina:       "81dc5dedf40a8bbb9c1a2b92483b62fa0e6f6543f79f6a7bfb77be1912a91006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6342f6edfdabdfd73eb44a07fc54688ef6ab03c9b45749ecc6447d61879f0e"
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
