class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.5.1.tgz"
  sha256 "193553eb0f806aa96bf7b13c2b24131a8b5e5c34275474b5b6e0bec30bc4620b"
  license "MIT"
  revision 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a6fb2febc1f62bba9e377ad9de5ba471166b3a47614388335fb01a52a0060a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a6fb2febc1f62bba9e377ad9de5ba471166b3a47614388335fb01a52a0060a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2d3f823af1204d8723de82a4a5fd9319b9337e8b425ec4400c437b8ff0f929"
    sha256 cellar: :any_skip_relocation, big_sur:        "68626d0279034e923d57f5afde817db13e3edee2f4a84c1532e3ca9a544b0ebc"
    sha256 cellar: :any_skip_relocation, catalina:       "68626d0279034e923d57f5afde817db13e3edee2f4a84c1532e3ca9a544b0ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a6fb2febc1f62bba9e377ad9de5ba471166b3a47614388335fb01a52a0060a"
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
