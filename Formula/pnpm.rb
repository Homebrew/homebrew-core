class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.14.3.tgz"
  sha256 "15ebcab477230c49696db14f0d3289790262dbe2b8770c6656eb71b08562d77e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9619bc4a88c4c9235357e5d926b81aa444d26b322c16b8675d2d834188ba3ddc" => :catalina
    sha256 "986de8a46fbc3cca2fa97f7ffae6a528d45413b83336384fb72da2918f68c15b" => :mojave
    sha256 "1922f67940bffb5856765afa4ff70a35fba9ca5d257108ae0b3787e4ea11afa1" => :high_sierra
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
