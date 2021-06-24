class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.9.0.tgz"
  sha256 "95dc47a759a92235576da3c8dc55c1b63fcb55e5fcc8ee69989de1e850f48eb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32b8b35e8f38215ff413d6a2696894de5817e13ae8a04add992cbc150d518bd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b1ef185bee045b7633650504e3b5ae52c2affbe0a71a601267e8cd3b209eba7"
    sha256 cellar: :any_skip_relocation, catalina:      "7b1ef185bee045b7633650504e3b5ae52c2affbe0a71a601267e8cd3b209eba7"
    sha256 cellar: :any_skip_relocation, mojave:        "7b1ef185bee045b7633650504e3b5ae52c2affbe0a71a601267e8cd3b209eba7"
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
