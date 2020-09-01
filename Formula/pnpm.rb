class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.6.tgz"
  sha256 "47c0da06ea8843f55b2e2dbb7f9a846ab51b42a3d4109d4073e556398600abbc"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b3d094d735cce1781900cab18c08ff7937b6576706bb6d02480142cde8a4eb1a" => :catalina
    sha256 "f541551855c4630e22f0656830d3ce0a09bba1f717f13bcb659b929cf3f5e407" => :mojave
    sha256 "ad5b1bf08cfaa5358d5493194efc66488a5879ba273eabfdff579948285ee2bf" => :high_sierra
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
