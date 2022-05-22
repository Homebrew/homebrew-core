class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.2.tgz"
  sha256 "839b1b6c3b6504f08a56d78aa38d35d48bba76684fe391229f112c65e25f0862"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33a9035d51086568311de802dd366ae45050683fef00bddde58e041132380a2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33a9035d51086568311de802dd366ae45050683fef00bddde58e041132380a2d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ee6377d4506654873a07cda17f534fbb9768f85d1e5fe43e387bf2df32c287e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9da8e5b82006558b3b0e21ac3cc8d7c870e1254143e71d95a6f5faee52d105ca"
    sha256 cellar: :any_skip_relocation, catalina:       "9da8e5b82006558b3b0e21ac3cc8d7c870e1254143e71d95a6f5faee52d105ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a9035d51086568311de802dd366ae45050683fef00bddde58e041132380a2d"
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
