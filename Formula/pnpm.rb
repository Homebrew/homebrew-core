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
    sha256 "f3149add0a41d85253075d8f825e560f79bd2319135450d7c6d13b784c2f2a41" => :big_sur
    sha256 "d934d9fc6c3a3251299f2f4d95e6005118c32ee38f507a7e09d77951f67b5646" => :arm64_big_sur
    sha256 "6fe403a3ac91dcb1e111ed6ec31b948fb52c3169442644e9b0b5e2bcc06d51bd" => :catalina
    sha256 "416d0b9a3c6b10663099e7da624763f685b0509b6011a2401e96e7a291c50db1" => :mojave
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
