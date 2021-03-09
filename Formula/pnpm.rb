class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.3.tgz"
  sha256 "d14a4eedf8be5da8fe60dcd0e8849ce870b75e424c7bceccb548b63b15239fdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4daecac5f8f42ebc2a815a22239bdb4fd3329f2be311cb11f5f88563a8647659"
    sha256 cellar: :any_skip_relocation, big_sur:       "a58820d6bd51b2a426f3d4df3bd9a58efc9380cde2873aa062b88a2ef28c0fb4"
    sha256 cellar: :any_skip_relocation, catalina:      "cd3a73e87a2423a099903d9705222867010d7c2824473bbd3237c929bd1dbc78"
    sha256 cellar: :any_skip_relocation, mojave:        "acf3a4301d49bad888f39721514a026f75efe1bdd50c75b3dc43e55d10900c66"
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
