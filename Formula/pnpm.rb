class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.6.1.tgz"
  sha256 "826df94ac0535f2fc67c5656cfc09ceb873eab7f584e12b6d8043028900549c8"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "81ec69cc8a1973cb137c9ab820cdbc800b109dc7f39444609909aaf6f52895f1" => :catalina
    sha256 "5a1ecdb5d9e6fd7584d832696ea898572acd27215de0da297ed4a88ae027e0ef" => :mojave
    sha256 "633afb6d80877f4fe181309cd1ccc0a093bcbc3e2b5206e67d790d592da9e1e5" => :high_sierra
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
