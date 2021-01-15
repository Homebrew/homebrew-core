class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.15.1.tgz"
  sha256 "f6e8901cedd18188fe66be93fdb43569b5b25ce2542e61e427a4ed420f03cd26"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "67ab825d315bfff7c72f24f95840616a7c2e333db9456b7668365afa5b378642" => :big_sur
    sha256 "6556a252ac49974103df51b819de20ad5080d8c4a85ac92000db43db23cf97c5" => :arm64_big_sur
    sha256 "58a4f0d7ea8b26fbb0062babf463cd157faaf40dcacf691e4d696a8d5dd774eb" => :catalina
    sha256 "bd7e0346d23f01ada41919829075d3e16fc12ab6df780e39fcf0a3ecec532de4" => :mojave
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
