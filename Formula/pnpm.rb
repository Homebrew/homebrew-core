class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.14.2.tgz"
  sha256 "f9e3d3c34c9cb5298702fc5ffd9f082fd0c381f78b586b02a64dabd5c3d02fdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c51516320d2c9ec23146a1d61dcc030f6abc6382912c0d534c3c258a350b56f7" => :catalina
    sha256 "0e148cc5e7d648c7dc26f15d973bf2506e209726eea0db225369bdd3184b98f6" => :mojave
    sha256 "d86a8bcb8071b22d5887803b287b5a0b7ef28c55efb1f798a73300bb5d4a8cd2" => :high_sierra
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
