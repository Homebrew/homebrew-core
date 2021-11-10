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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d8cded4e6d0b8a31a5d010ff432717281251948bcc57ba4f891509acf5579ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d8cded4e6d0b8a31a5d010ff432717281251948bcc57ba4f891509acf5579ef"
    sha256 cellar: :any_skip_relocation, monterey:       "cf82ef1a64c7502d55af4d490382190d4ab026dadecfae85a8fd5dae218d914c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddd1dbe121f3e810ced033b94aaf88e657b4efaa7183ac221713084e74e5e5f8"
    sha256 cellar: :any_skip_relocation, catalina:       "ddd1dbe121f3e810ced033b94aaf88e657b4efaa7183ac221713084e74e5e5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8cded4e6d0b8a31a5d010ff432717281251948bcc57ba4f891509acf5579ef"
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
