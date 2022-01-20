class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.27.1.tgz"
  sha256 "ef7e261dd5f3304488536b70d9ea37c4405f2bfea3a85fc113d0513967fcfdf8"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "971ad0f3c0007b31b2ee34c841e16fc4a26ec5bc13839877afc80073dd13f877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "971ad0f3c0007b31b2ee34c841e16fc4a26ec5bc13839877afc80073dd13f877"
    sha256 cellar: :any_skip_relocation, monterey:       "c8765b720c56bd4f3eb1aa2292bba562b93c1067602b78558437fa1701c3fcdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27dedcf8b65d713f284e2d64f062df8c519db280fe845ea48b5d952ba798b82"
    sha256 cellar: :any_skip_relocation, catalina:       "e27dedcf8b65d713f284e2d64f062df8c519db280fe845ea48b5d952ba798b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971ad0f3c0007b31b2ee34c841e16fc4a26ec5bc13839877afc80073dd13f877"
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
