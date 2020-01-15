class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.7.1.tgz"
  sha256 "957e573ac1552c0c8793a72eab192e11e7473b84e7c6bfde1c31d0224d234f20"

  bottle do
    cellar :any_skip_relocation
    sha256 "443c20c378d924da19765f3cc780e99e463f004364675db8257779f5880ed0b5" => :catalina
    sha256 "74e864c4f16e4bab9efcdd7545bea790b90f19e998815789aa404ae7cb5af566" => :mojave
    sha256 "4512b756e24d008a252abd0b68bbdffc3b3818e224a905c2b0912f144008c0f3" => :high_sierra
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
