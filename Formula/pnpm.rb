class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.27.0.tgz"
  sha256 "52649d38cff4e752c6af6ae544eff28a89b0899b918cd99febbd5a93ea7f9300"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c90ad350b9548cb426fbc610acdc2abe4729079a7673dc8ad1d90c2268f274e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c90ad350b9548cb426fbc610acdc2abe4729079a7673dc8ad1d90c2268f274e1"
    sha256 cellar: :any_skip_relocation, monterey:       "aa59c675b7132ae009881d442d02a5ce6a3db55671346f6bacee46017ab277ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d16cd3b575b275d36364728a06d56eb6d87fef5a2599721fe970244bc868dc9d"
    sha256 cellar: :any_skip_relocation, catalina:       "d16cd3b575b275d36364728a06d56eb6d87fef5a2599721fe970244bc868dc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90ad350b9548cb426fbc610acdc2abe4729079a7673dc8ad1d90c2268f274e1"
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
