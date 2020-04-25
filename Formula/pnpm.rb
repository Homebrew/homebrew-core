class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.14.1.tgz"
  sha256 "a129739bc117ca88a50f6af2f1e80f82aa417a5fbc393325e98ffa2c4076a55e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c67a896aab59e0895150539a6a0cedbf9823b7fabdbafcd4b39d437234594f5e" => :catalina
    sha256 "a1b72b8fea32641d64c245543d041a1bc98f4b7d0d425b86741f78ba7a762bfc" => :mojave
    sha256 "8b8d8d73343e96ca3c1adc1e79425f8b0730bd091951eee9296528a7147cbe03" => :high_sierra
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
