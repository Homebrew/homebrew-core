class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.11.0.tgz"
  sha256 "4806143590b74b52b5cca2e8851f1aefc7e8a66b6d06188920a1b3321653b913"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04bfe7aa51c87507033ed9277e9cbb9c218f2bb50b967491c33cd67932353e85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04bfe7aa51c87507033ed9277e9cbb9c218f2bb50b967491c33cd67932353e85"
    sha256 cellar: :any_skip_relocation, monterey:       "292a18f7053446e058ca75e65454be30d2c002a16050b550519fdabcaceafc9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "183c5c55cc25dfcbb6ad829e1e6dde9e3d3ff6975e04f7dee37eaa18da18b223"
    sha256 cellar: :any_skip_relocation, catalina:       "183c5c55cc25dfcbb6ad829e1e6dde9e3d3ff6975e04f7dee37eaa18da18b223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04bfe7aa51c87507033ed9277e9cbb9c218f2bb50b967491c33cd67932353e85"
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
