class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.13.5.tgz"
  sha256 "f0092c0ce3e5f401ef14b6665ade58ae6831e5b2d5c3ef6c246a216f6864759e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a88131b37d4c646b378b5a85184ae7e2e4018b9edd6cd8da3aa4843497b949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88a88131b37d4c646b378b5a85184ae7e2e4018b9edd6cd8da3aa4843497b949"
    sha256 cellar: :any_skip_relocation, monterey:       "04d4db9207f05f55573800ef078aa1d593aaa07119bfc8826ec37b1ebefd6312"
    sha256 cellar: :any_skip_relocation, big_sur:        "41ec220c0462d5872be2e13ebc3faaf524977362ef498dc673ace786ad2bb615"
    sha256 cellar: :any_skip_relocation, catalina:       "41ec220c0462d5872be2e13ebc3faaf524977362ef498dc673ace786ad2bb615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a88131b37d4c646b378b5a85184ae7e2e4018b9edd6cd8da3aa4843497b949"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
