class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.24.4.tgz"
  sha256 "fdcd9195cc9f86a93bf5dc5f0bd254217d23a15ec09d1a315fa573962f57bd7f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f60e065c7ff523d85dc841bfdd76175f5cea537395b27b97fbb8803699af3b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f60e065c7ff523d85dc841bfdd76175f5cea537395b27b97fbb8803699af3b6"
    sha256 cellar: :any_skip_relocation, monterey:       "a4154c7d7f772219a20b79ca48e79432b4d6fdcd949659fbeb5941b2c1ebd079"
    sha256 cellar: :any_skip_relocation, big_sur:        "289e645fdcf65cfd2734faa398bc54986688e17228bf90905381e749467b5bc6"
    sha256 cellar: :any_skip_relocation, catalina:       "289e645fdcf65cfd2734faa398bc54986688e17228bf90905381e749467b5bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f60e065c7ff523d85dc841bfdd76175f5cea537395b27b97fbb8803699af3b6"
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
