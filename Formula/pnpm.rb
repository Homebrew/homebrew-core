class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.22.1.tgz"
  sha256 "7aa88f16e4556006826f38812d01fe2adcc279d305ae37808e3e7a32e9eac1ee"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9338ca464fe5a1e17535987ada03e89d71a5c034ef9890d8e201971bbb18df03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9338ca464fe5a1e17535987ada03e89d71a5c034ef9890d8e201971bbb18df03"
    sha256 cellar: :any_skip_relocation, monterey:       "0c36e53b6e4b66feda3b6022f19edee51ad1077ed3779780bccea9eac6afea30"
    sha256 cellar: :any_skip_relocation, big_sur:        "53952467785b40014104ad5b9888b6049064060e1562d7806441ece409e79ef1"
    sha256 cellar: :any_skip_relocation, catalina:       "53952467785b40014104ad5b9888b6049064060e1562d7806441ece409e79ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9338ca464fe5a1e17535987ada03e89d71a5c034ef9890d8e201971bbb18df03"
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
