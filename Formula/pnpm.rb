class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.0.tgz"
  sha256 "0d8a7bc2b91801831a3e6cb295900936bac8fef2c2215c3af76facaf41f880b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "243d08bffbe5ea4a9048f7b5271de9e0605172ef22b9919463b399720820b259"
    sha256 cellar: :any_skip_relocation, big_sur:       "7230b68b8de579e9c0a612304142956b7e43e3572a52f7f8e5b0089b940e4973"
    sha256 cellar: :any_skip_relocation, catalina:      "7230b68b8de579e9c0a612304142956b7e43e3572a52f7f8e5b0089b940e4973"
    sha256 cellar: :any_skip_relocation, mojave:        "7230b68b8de579e9c0a612304142956b7e43e3572a52f7f8e5b0089b940e4973"
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
