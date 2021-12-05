class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.23.6.tgz"
  sha256 "56d9f8d2951a4b287db46f25cb6c163af32bcfbbb4cb1a27e41e3ad27da72eee"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e519690082670e8715f0921c6f48aef1cfa6f3755d8838a707bc5a83a78509"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53e519690082670e8715f0921c6f48aef1cfa6f3755d8838a707bc5a83a78509"
    sha256 cellar: :any_skip_relocation, monterey:       "9174ffc9d1c84f54630f19344286ae9c6b194c592824f65178c31c5014e28451"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da6a963e004c0f014de310481382f333da9f6a94f56a493a16e37a39bdd5400"
    sha256 cellar: :any_skip_relocation, catalina:       "4da6a963e004c0f014de310481382f333da9f6a94f56a493a16e37a39bdd5400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e519690082670e8715f0921c6f48aef1cfa6f3755d8838a707bc5a83a78509"
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
