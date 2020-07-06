class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.9.tgz"
  sha256 "cc26f5f93300cf9b12d3a08fc8343516150fb3572cb956c72b5da5b1f710eee7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "71fe4e3d04e1e5d9dbe806c958c3444e92426cadec1ddb80b29cc8a62ecfe7cb" => :catalina
    sha256 "f5ab322752d39399329cecc97ed1f83d00fde6e24c53837a361566fde94aa686" => :mojave
    sha256 "6b5dbe0b61802a915670a3c2e6a8175f50ac030516e70275e3cb74de556e19e7" => :high_sierra
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
