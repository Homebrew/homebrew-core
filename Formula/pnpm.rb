class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.1.1.tgz"
  sha256 "81fa42eae93570f569460def1cc0ad8bb7601a25304be6f61742a69a22d6645c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eab7d4e15c1a07a9c6d6a157929d80cf2b6e46a4f484c8039f49e133f8a057a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eab7d4e15c1a07a9c6d6a157929d80cf2b6e46a4f484c8039f49e133f8a057a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eab7d4e15c1a07a9c6d6a157929d80cf2b6e46a4f484c8039f49e133f8a057a8"
    sha256 cellar: :any_skip_relocation, ventura:        "48dba7ffab6f86c62f936fe61b8495bd837a75bb755a808dc47eed43af9bd6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "48dba7ffab6f86c62f936fe61b8495bd837a75bb755a808dc47eed43af9bd6b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c086e87aec5885db0cf48e8b0b6d43d34187f1eee50b66279ce22ced501d6bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab7d4e15c1a07a9c6d6a157929d80cf2b6e46a4f484c8039f49e133f8a057a8"
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
