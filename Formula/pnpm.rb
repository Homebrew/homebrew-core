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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "963de7da8c60ed8fcd51bebb954a3ca61755d44dfc39d22cf84619b021615c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "963de7da8c60ed8fcd51bebb954a3ca61755d44dfc39d22cf84619b021615c69"
    sha256 cellar: :any_skip_relocation, monterey:       "1d2d2d48f8f05c104fbe5f380c74fedfb085c3570a3b0814c5e3b0ba6f37b662"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b1622f2b5768569ea57c6016626689cdc37757df2996ed9c7a559899894fda6"
    sha256 cellar: :any_skip_relocation, catalina:       "2b1622f2b5768569ea57c6016626689cdc37757df2996ed9c7a559899894fda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "963de7da8c60ed8fcd51bebb954a3ca61755d44dfc39d22cf84619b021615c69"
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
