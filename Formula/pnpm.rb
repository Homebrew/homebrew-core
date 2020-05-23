class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.14.4.tgz"
  sha256 "d9ace242533036659a9696bd64c6f3849e64143471ad6921872be1d026741b10"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae61c95b02ca652a58c44c347567d46f2d1a2a24d7f9cd79bf1f532132e0c5f" => :catalina
    sha256 "cfe43030eb6ead3679c348e74ea06e8d45fc55e1215ceac97c60c981d4998fa0" => :mojave
    sha256 "472cafa1e4e9ae5a6caa33dcdee411dba269f01903bd4c3493d5821bdd2a2716" => :high_sierra
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
