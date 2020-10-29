class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.10.2.tgz"
  sha256 "fbbb9a49d0f3ee4655f993c8a217982193b421c46e9e0405e0147f42af0949c9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2b22d846d35902a1e94f0d1cff5df96049ea0aff68799220fedb3a4a80049c98" => :catalina
    sha256 "d06699584005ba152345499084f194742d59707de52fbc280f2d881c72c70a4f" => :mojave
    sha256 "87b3c3d8f1b4c45bf4dc6373e64f20f6e2fe2e00b8f138e9c514a37ae5d9257d" => :high_sierra
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
