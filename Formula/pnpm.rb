class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.9.0.tgz"
  sha256 "db498a824067574b6275871cd6060cc374a9f2d464b9b344d2e1cc8ed1077090"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b3e16b84dd7ba09a1e5b420cbede526aa8d8dfbc3fa394ef18c9fe47dc5b6237" => :catalina
    sha256 "852fdb0bb39a1606fa0ede9a4a04b99b9354eb4b07a17c7c56ccc37c09799ad0" => :mojave
    sha256 "e1774a0e765af630a542eb37d6af66ec2dfbae15b53921f49c044b10b8479912" => :high_sierra
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
