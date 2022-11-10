class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.15.0.tgz"
  sha256 "931baa5a648afd26c86176612091ffe8431d05103c7aa09fd170d9f4c5ad7db7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14282d3010b5a0b5d11893f9b66eb5e383b6208e3f2de5d56b3513eba2ce48cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14282d3010b5a0b5d11893f9b66eb5e383b6208e3f2de5d56b3513eba2ce48cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14282d3010b5a0b5d11893f9b66eb5e383b6208e3f2de5d56b3513eba2ce48cc"
    sha256 cellar: :any_skip_relocation, monterey:       "29fd746314039c25db607bae8319949c8035d813c927462222382dd3c6d46949"
    sha256 cellar: :any_skip_relocation, big_sur:        "09e958787d54de551770fd044e6285745fa2e2106761eb1a57d5ce4773655655"
    sha256 cellar: :any_skip_relocation, catalina:       "09e958787d54de551770fd044e6285745fa2e2106761eb1a57d5ce4773655655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14282d3010b5a0b5d11893f9b66eb5e383b6208e3f2de5d56b3513eba2ce48cc"
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
