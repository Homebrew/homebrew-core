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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3777ee3341e7b46c489943357f49e08d7c5bcb5e819c2f415502780f0029c5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3777ee3341e7b46c489943357f49e08d7c5bcb5e819c2f415502780f0029c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "a22bd811ada87b5b8dfa0ac15630d8bd99553aaef14be8c22b734f846a3892c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "68e760448fccc8304a12012b8b2c96e4f6cdeb82da1eaf4b0b201f9606035278"
    sha256 cellar: :any_skip_relocation, catalina:       "68e760448fccc8304a12012b8b2c96e4f6cdeb82da1eaf4b0b201f9606035278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3777ee3341e7b46c489943357f49e08d7c5bcb5e819c2f415502780f0029c5d"
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
