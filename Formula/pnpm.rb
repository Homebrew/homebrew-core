class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.17.0.tgz"
  sha256 "994279d1cb369c519ce0138da6e3d16c26653c3cdaf365e881a200ff13606897"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "285acbb7e4ae1f093030b9918cc5fc54734b7f0f71e4d3f73a81ba559e5245d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f18ad0748a4766aa6903e7eccd5adbc8d70028e0d304fe322478da89ba7d4c2f"
    sha256 cellar: :any_skip_relocation, catalina:      "f18ad0748a4766aa6903e7eccd5adbc8d70028e0d304fe322478da89ba7d4c2f"
    sha256 cellar: :any_skip_relocation, mojave:        "f18ad0748a4766aa6903e7eccd5adbc8d70028e0d304fe322478da89ba7d4c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285acbb7e4ae1f093030b9918cc5fc54734b7f0f71e4d3f73a81ba559e5245d9"
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
