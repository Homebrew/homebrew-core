class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.5.tgz"
  sha256 "0720db66f1497cf87959ac6ec585c6d119a460402e93b7ac7e230ba87795e689"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c6e99eda3ac41d3f16cdc1c0f6d917020fe73acd0796531eb378080228659f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c6984eca4bf24118d0170576bde5d9c651749a19b5c106b9e542e968a0d54b5"
    sha256 cellar: :any_skip_relocation, catalina:      "1c6984eca4bf24118d0170576bde5d9c651749a19b5c106b9e542e968a0d54b5"
    sha256 cellar: :any_skip_relocation, mojave:        "1c6984eca4bf24118d0170576bde5d9c651749a19b5c106b9e542e968a0d54b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6e99eda3ac41d3f16cdc1c0f6d917020fe73acd0796531eb378080228659f1"
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
