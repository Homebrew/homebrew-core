class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.29.1.tgz"
  sha256 "bfd5b9a62ebd51491635d83ae2d7d18aea135721b9205a3e29dc4c2356e6d504"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb0f22af04be06b38c664dcf1d9bb8d2753ac86ff18f2dc25c17264551a964d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbb0f22af04be06b38c664dcf1d9bb8d2753ac86ff18f2dc25c17264551a964d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbb0f22af04be06b38c664dcf1d9bb8d2753ac86ff18f2dc25c17264551a964d"
    sha256 cellar: :any_skip_relocation, ventura:        "ca352b2775e79723b1f487decbd201be98ac90f39f44830595d2a550ef4e08f9"
    sha256 cellar: :any_skip_relocation, monterey:       "ca352b2775e79723b1f487decbd201be98ac90f39f44830595d2a550ef4e08f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dbfbba1d9947e5ca824f021dbb3d517811a8c0a4f910745c5b1ffa252477961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb0f22af04be06b38c664dcf1d9bb8d2753ac86ff18f2dc25c17264551a964d"
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
