class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.13.2.tgz"
  sha256 "e8c3eee8f6c0d6d47e31e35dda164b68289a3e6e98ddaad512304b0559b37787"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e5f7034eab005926b9d94845b9169343e4a5f120522136ce961f3730f972301a" => :big_sur
    sha256 "1f851ce94f39ea6a50f07e60cb121689a874f24dc541965580d721faf2a14896" => :catalina
    sha256 "dce689a8c6efe6970de604a402949377d6f36d8031b1b2fd00c6c13b7f2a83ec" => :mojave
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
