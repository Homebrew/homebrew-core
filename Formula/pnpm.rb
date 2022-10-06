class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.13.2.tgz"
  sha256 "a3e4d1917c9ec75a100388f955efb70ace7cabf9268dcf5b8e67e979211a9df2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24508a55bacbcee62f5f078422a68912a4a44f7715cdd330cb488422ff4def5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24508a55bacbcee62f5f078422a68912a4a44f7715cdd330cb488422ff4def5c"
    sha256 cellar: :any_skip_relocation, monterey:       "5998df4dd43e7e0dec48fdd6978456001c8104f7be7589770e5babc4e9bda3cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f85bd0f8f5c3170f77f9f70517c29edbec005282ce0520cb605cbe9a04077ef3"
    sha256 cellar: :any_skip_relocation, catalina:       "f85bd0f8f5c3170f77f9f70517c29edbec005282ce0520cb605cbe9a04077ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24508a55bacbcee62f5f078422a68912a4a44f7715cdd330cb488422ff4def5c"
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
