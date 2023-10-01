class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.6.tgz"
  sha256 "c95869d443ed8fd6b7bb164bb8e89b56cabdc24f3c79b87ef68d8ae1c6b1d0e2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c1be30a455f6bef2d96fe6215f527c33aa9b2e080e4f4c99da4696b308d1770"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c1be30a455f6bef2d96fe6215f527c33aa9b2e080e4f4c99da4696b308d1770"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c1be30a455f6bef2d96fe6215f527c33aa9b2e080e4f4c99da4696b308d1770"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c1be30a455f6bef2d96fe6215f527c33aa9b2e080e4f4c99da4696b308d1770"
    sha256 cellar: :any_skip_relocation, sonoma:         "03b9ff712ec76351c91346b90ae74a6da1de342765c485e2271944cffe357576"
    sha256 cellar: :any_skip_relocation, ventura:        "03b9ff712ec76351c91346b90ae74a6da1de342765c485e2271944cffe357576"
    sha256 cellar: :any_skip_relocation, monterey:       "03b9ff712ec76351c91346b90ae74a6da1de342765c485e2271944cffe357576"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddd20679488445df2d841c8f9e8214c2663df150c672e91ef86f4dc78fc13c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1be30a455f6bef2d96fe6215f527c33aa9b2e080e4f4c99da4696b308d1770"
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
