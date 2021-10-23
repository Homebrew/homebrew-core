class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.19.0.tgz"
  sha256 "50301d29c56a86f3a0f8e417003512e5eee0e5b377e441d7211249075ab60955"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90f4bfa844ecbf63c420e1afb045e7c989013e4ead33aa9fde86dc0c72dd1dab"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c7ae9d2b4050fdb126888fb16dc0fc03ae674350d368c9ffc692060c97b1a33"
    sha256 cellar: :any_skip_relocation, catalina:      "6c7ae9d2b4050fdb126888fb16dc0fc03ae674350d368c9ffc692060c97b1a33"
    sha256 cellar: :any_skip_relocation, mojave:        "6c7ae9d2b4050fdb126888fb16dc0fc03ae674350d368c9ffc692060c97b1a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f4bfa844ecbf63c420e1afb045e7c989013e4ead33aa9fde86dc0c72dd1dab"
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
