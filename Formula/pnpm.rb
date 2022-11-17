class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.16.1.tgz"
  sha256 "843ecd1e70f627c2a2071b5b7c7b1920576665d23344f145c557a847df72eb58"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59e67d4b012737b8a6925a02ad172b2c2f924ae1f6ee72ad49395f376c65bba4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e67d4b012737b8a6925a02ad172b2c2f924ae1f6ee72ad49395f376c65bba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59e67d4b012737b8a6925a02ad172b2c2f924ae1f6ee72ad49395f376c65bba4"
    sha256 cellar: :any_skip_relocation, ventura:        "cfe560e4fbbecbcb018c235558581c5dfa2ec2ec149a8c31a89b93fb12023abf"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe560e4fbbecbcb018c235558581c5dfa2ec2ec149a8c31a89b93fb12023abf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecd2ca7af7f7214527877260011d9630a2cab08d479d5ea56985b6fc2cae0565"
    sha256 cellar: :any_skip_relocation, catalina:       "ecd2ca7af7f7214527877260011d9630a2cab08d479d5ea56985b6fc2cae0565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e67d4b012737b8a6925a02ad172b2c2f924ae1f6ee72ad49395f376c65bba4"
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
