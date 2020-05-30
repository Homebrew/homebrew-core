class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.0.2.tgz"
  sha256 "8635d81b95ec33e314c430baff6cf605a824589377f2a4b0d0dd193e55e56444"

  bottle do
    cellar :any_skip_relocation
    sha256 "654035bd0dcb39c8b2a22f33486882e89ac53d2e3dedcd3ab32ec08e5ba73e85" => :catalina
    sha256 "a202c489fe8fd6010bbdb8118fd6aa6125d19e1b35091a4f4c91603af9160473" => :mojave
    sha256 "7046a2ebd323560dbd09609b2a8fb7372c6135e2e71ef53c308d6196ef7c8aea" => :high_sierra
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
