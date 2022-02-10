class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.30.1.tgz"
  sha256 "568c6512208f31f58f9a23dd8130ab600444b03653d331ed4b7d29be9ff2ed4b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ac192386a45d57920549ebdb8c3ab73fae8127bd17657d018b0c60c0d0e02b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69ac192386a45d57920549ebdb8c3ab73fae8127bd17657d018b0c60c0d0e02b"
    sha256 cellar: :any_skip_relocation, monterey:       "6802d5dd18589a183cc84da5e7da3257f8c6052ff46a07fbfee53f94574c9fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f82759a81142902fdf9293f9045e66a65b37d5a0c92953afd52359a7ecbb6fd"
    sha256 cellar: :any_skip_relocation, catalina:       "3f82759a81142902fdf9293f9045e66a65b37d5a0c92953afd52359a7ecbb6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ac192386a45d57920549ebdb8c3ab73fae8127bd17657d018b0c60c0d0e02b"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
