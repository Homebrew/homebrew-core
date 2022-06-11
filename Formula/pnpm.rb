class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.2.1.tgz"
  sha256 "c5fb3e8e09c78887dddd91bc5b3465fe298fb50ac796f9a45e560b2d69a717ea"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35276d7f79c4b632e18bb643b299ad05c5e8ceb7d7828371addbb47be472d4d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35276d7f79c4b632e18bb643b299ad05c5e8ceb7d7828371addbb47be472d4d7"
    sha256 cellar: :any_skip_relocation, monterey:       "fb8e8bddf5c97cfd2c859b0bcc6ad18cc1c665df220c886f5b297071422d3c95"
    sha256 cellar: :any_skip_relocation, big_sur:        "133ceb244b07e4fd7feebb05f9507da5360fa4d2ccbfc0d7a60e420273aa7e75"
    sha256 cellar: :any_skip_relocation, catalina:       "133ceb244b07e4fd7feebb05f9507da5360fa4d2ccbfc0d7a60e420273aa7e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35276d7f79c4b632e18bb643b299ad05c5e8ceb7d7828371addbb47be472d4d7"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
