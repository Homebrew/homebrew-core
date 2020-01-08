class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.6.0.tgz"
  sha256 "fbae5d44eec703d74d7f551d0860115e6114f407991d1efea1a7294da8ec48b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "20a90e2221a72bdb227d199b2a06b278f4b9ccce6c4c6f2c69a870a6732090ff" => :catalina
    sha256 "0af04ae6fd62bd0e60f67864418a1a027db776e2be4f48edefccdad55d9af885" => :mojave
    sha256 "14bc7f54900c130fddbc6eaa44dd59c686539a9e5966fdeacab9b3fa31bf5e1d" => :high_sierra
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
