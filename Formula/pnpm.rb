class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.13.6.tgz"
  sha256 "37e2598f9f2ed31a72cf5d5da23ce907e40af61835e2835a61f1e2e6bab568a3"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "67b32e743ef1900e24c37f940fb0f9828fa1c9e509a7b8f036dc54b252596c8b" => :big_sur
    sha256 "ded1368fc5934cd9ecb5a1137f6d4e1a4da56c4bdaaacfa04bdfc6291b4ee2b6" => :catalina
    sha256 "8e1393d61415866d0988724025430a4ad41f2cfa0c734a4d10eaa5cc69032e2c" => :mojave
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
