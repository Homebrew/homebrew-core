class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.12.tgz"
  sha256 "9e2de4aa235c3d8e7ca06f766266f8dcbb503a3ea9163e91066086f4390c8849"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a040db1ef90aea1628463fcf8905a04225b196fce109f84d2a49ae41d0902bd" => :catalina
    sha256 "60301c7dda9de62587083b8dcd2d8f8ed1188150dd4474c6deede7d70a860873" => :mojave
    sha256 "ad9d8227d86e224bbff8deb61964ea74d000acffee50112b1588b7f6e97be360" => :high_sierra
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
