class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.1.4.tgz"
  sha256 "9898b1afaef9b84fb7216b7b4d59825167057fe87edbe83c2e310b17c64e56a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2d5b8859da25a7543e4765e8205985146e818ba34f17a70bd97e0e52bb22854" => :catalina
    sha256 "6d4533ea596c58d27632e50ae6e6c3626211450c192a6d9105126919bc66131a" => :mojave
    sha256 "2e8f951512d55be9ca77b7bd756e129c43964859b9593815288e5d67a17f521f" => :high_sierra
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
