class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.24.0.tgz"
  sha256 "2540d2376190543462d7e3d30cedec3093d27bd423231f40bf1eec0b19f127b6"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9fe4f1e47e9b9833c30ba47a2987d26c45e4a83d4f92a50a395f3fe27bf7e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9fe4f1e47e9b9833c30ba47a2987d26c45e4a83d4f92a50a395f3fe27bf7e3e"
    sha256 cellar: :any_skip_relocation, monterey:       "33be4bf6432a5f5d1921e08e8138582cf6431349652202e7121f0d6bb44e740c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a5ed969e069f43d81803910d270d4379d410f2391e4af76498d1c9989bcbc1d"
    sha256 cellar: :any_skip_relocation, catalina:       "8a5ed969e069f43d81803910d270d4379d410f2391e4af76498d1c9989bcbc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9fe4f1e47e9b9833c30ba47a2987d26c45e4a83d4f92a50a395f3fe27bf7e3e"
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
