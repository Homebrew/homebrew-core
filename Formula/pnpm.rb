class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.26.3.tgz"
  sha256 "aada815119cfe407f0c55b21b2cb3ef4f3c89e8dea4cc09c19e9506241998071"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9acaefbf142a63ac3528d36aa0e10eb5ffeb419e18e80e2cdf8e798cc03a3efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9acaefbf142a63ac3528d36aa0e10eb5ffeb419e18e80e2cdf8e798cc03a3efb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9acaefbf142a63ac3528d36aa0e10eb5ffeb419e18e80e2cdf8e798cc03a3efb"
    sha256 cellar: :any_skip_relocation, ventura:        "269e21116f4810035b5d5e921afb925a8f76aacbc72562e975d02a5a2661b6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "269e21116f4810035b5d5e921afb925a8f76aacbc72562e975d02a5a2661b6d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "df45fea2cd539208a46da8b6ed9b19aca5219a1f5d6f2b0a1b9743b2787593d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9acaefbf142a63ac3528d36aa0e10eb5ffeb419e18e80e2cdf8e798cc03a3efb"
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
