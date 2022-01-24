class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.28.0.tgz"
  sha256 "3ac229d647ae6d0a343ed78de4583e4b6408534adc9f13e1d27a7781b2d4bb34"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "116e365fe5bad56fd931020d289e90621ee3969e8e757b4a60db94f150c0416f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "116e365fe5bad56fd931020d289e90621ee3969e8e757b4a60db94f150c0416f"
    sha256 cellar: :any_skip_relocation, monterey:       "c25ac49c48ee5bcbfddb052c3b033e9f9ff1de995cb52af0453a3e7eda157012"
    sha256 cellar: :any_skip_relocation, big_sur:        "0605044cff0b88c6b24f34c271fab8dc170c8698748feeafd29cc6279c786094"
    sha256 cellar: :any_skip_relocation, catalina:       "0605044cff0b88c6b24f34c271fab8dc170c8698748feeafd29cc6279c786094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116e365fe5bad56fd931020d289e90621ee3969e8e757b4a60db94f150c0416f"
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
