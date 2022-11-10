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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d0c2ac17f776c3eafc1bcb236669bd050b555d187a4f8a793821729ff6c6ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d0c2ac17f776c3eafc1bcb236669bd050b555d187a4f8a793821729ff6c6ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d0c2ac17f776c3eafc1bcb236669bd050b555d187a4f8a793821729ff6c6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "d3411d51114829ec8639743ef03b38b7f1b1f4ee567aa6d1e1462bd0d51545a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "461f61e62d55ea9a41d811b1881ed6fe64b6e534632b36b7df66caf60faf7a59"
    sha256 cellar: :any_skip_relocation, catalina:       "461f61e62d55ea9a41d811b1881ed6fe64b6e534632b36b7df66caf60faf7a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d0c2ac17f776c3eafc1bcb236669bd050b555d187a4f8a793821729ff6c6ed"
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
