class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.4.tgz"
  sha256 "449182787e162b7aa5040fb303e622151f637249737d71737eb372d13cedcd63"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "79611bcde32f28f79d0ebfa9674e3d0a041b221b22c3a1c5b8798533d596b732" => :catalina
    sha256 "4f03bee8f71f4b842d1fb7c52230ca09d3a15c941c91241d4923f5d147667552" => :mojave
    sha256 "76a2ca026398d0e528300455082083488900b8ffee9812bd8df309130326f061" => :high_sierra
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
