class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.15.3.tgz"
  sha256 "c2cfacd98e73838fb487cbf8e38b1fd8f8c01015bdb4e65557192ea57ca0137f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "34aa967ac68ad8339d3ee133eba4389a8490092d182fc8ebaa9c42899fee663b" => :big_sur
    sha256 "a3427caa37dc9e070d6b89b2a23da5d52377a1d4d36d06f1b14e8c5b2bc698a2" => :arm64_big_sur
    sha256 "539935eb7de336fb563388e33837562b8b15f8ecb2719afaa8f31f1cde663d34" => :catalina
    sha256 "c12002b16e166463ab12c2d7d620568133537941c2f47afe6d00f8b8ed6c855b" => :mojave
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
