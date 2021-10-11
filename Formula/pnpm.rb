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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb66c095e837f64c0b857a2c60ac2fcc6035b82fb14b141bebf40ba1080ec74a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c421decbcf273ed94657f4a3225600ea1ed92899918c02411c9f39cc2013ca87"
    sha256 cellar: :any_skip_relocation, catalina:      "c421decbcf273ed94657f4a3225600ea1ed92899918c02411c9f39cc2013ca87"
    sha256 cellar: :any_skip_relocation, mojave:        "c421decbcf273ed94657f4a3225600ea1ed92899918c02411c9f39cc2013ca87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb66c095e837f64c0b857a2c60ac2fcc6035b82fb14b141bebf40ba1080ec74a"
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
