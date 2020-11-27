class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.13.5.tgz"
  sha256 "39a19943d4494f4aa71a1eadc2f5c4f9122657639708bc625c7f284807d07fa1"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c35f400823dc3f596417f6dccda3de1e027943469c2c6f8cb4a9cb3602fcf4a1" => :big_sur
    sha256 "289f192dfa95abec3cef0ac6e7b88ed506e34d807df3ab6594b1335aafd0cb0d" => :catalina
    sha256 "d0f936f90bf9306963a5f3c40490d1d58f4b98c5c935a7e4db38ea73ea9365d6" => :mojave
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
