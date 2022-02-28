class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.2.tgz"
  sha256 "db76fda0fc0bae5a22652504129a0356edd8aa6e0bebb67a33d941de87bf1684"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea6c579851fdde021e7e8dc1bbecb4427a9403f966759cbaa06cb96a8462e82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cea6c579851fdde021e7e8dc1bbecb4427a9403f966759cbaa06cb96a8462e82"
    sha256 cellar: :any_skip_relocation, monterey:       "ada79d2cc84acb6b1a13f3de7daf35f75a88e6ff8469ad3ecdc62c960835b0b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b9b52851e60c7fc69100ecaedd30a4695393132780e5d8fa97055017e2c252e"
    sha256 cellar: :any_skip_relocation, catalina:       "1b9b52851e60c7fc69100ecaedd30a4695393132780e5d8fa97055017e2c252e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea6c579851fdde021e7e8dc1bbecb4427a9403f966759cbaa06cb96a8462e82"
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
