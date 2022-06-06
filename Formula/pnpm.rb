class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.9.tgz"
  sha256 "d75f65d04be0b517757fcd9472050d7b5a2a58835409683f54fc88fde95f016b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa7e2e3f4f48dc5a7e3db92699087bafa67e5c0d6805aaaf61a0cdd1eb8747f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7e2e3f4f48dc5a7e3db92699087bafa67e5c0d6805aaaf61a0cdd1eb8747f8"
    sha256 cellar: :any_skip_relocation, monterey:       "fcce0eae679734e9930ae512c9b1282bc8b800a047fd299b6ad633e8454808f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "49e36e7d022b654d1e127bd8f6a80bcede39843b2208069489d08006d38bcf38"
    sha256 cellar: :any_skip_relocation, catalina:       "49e36e7d022b654d1e127bd8f6a80bcede39843b2208069489d08006d38bcf38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7e2e3f4f48dc5a7e3db92699087bafa67e5c0d6805aaaf61a0cdd1eb8747f8"
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
