class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.16.0.tgz"
  sha256 "1b9c9bb0c5dc77b16f8d6788d7cefed8f36dc6b6f1ba619d3b9f2dfc58939457"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4f5b57b3adea427c661869c8007da845dcd03056e56e2dc3afa1ac853c9297c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcd4fff98abe6003bf78452c67e85b91e080922204a703147fb6b82931d4e20b"
    sha256 cellar: :any_skip_relocation, catalina:      "9f3dcfa8356e778fff7c11288ae8ff9e2c9cc3a8c7696a4f70ce2653015537b9"
    sha256 cellar: :any_skip_relocation, mojave:        "490740369b91b01358d6f29cc119e807a452e0e71cf4eca5cc088c3c5ab5916d"
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
