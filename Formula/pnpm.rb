class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.15.2.tgz"
  sha256 "8b1701722ac1ffba3edbd2ea06c23c0385ee85d190ab425f17d215dfae0d3b2f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0d669c48801ee9a3f0a49d99f81f2a50dcd1e879526b77a1367c1ae6daa9811"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, catalina:      "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, mojave:        "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d669c48801ee9a3f0a49d99f81f2a50dcd1e879526b77a1367c1ae6daa9811"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
