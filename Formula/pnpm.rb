class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.18.1.tgz"
  sha256 "0206fea9bca3e359ed32cd7b489a02d6f9eb5892c88b875f46150517f723613b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5729d439b77dd7f2fe7ba6cff95d82322d62940634b93eb6109f854d9e320bd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5729d439b77dd7f2fe7ba6cff95d82322d62940634b93eb6109f854d9e320bd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5729d439b77dd7f2fe7ba6cff95d82322d62940634b93eb6109f854d9e320bd9"
    sha256 cellar: :any_skip_relocation, ventura:        "54001eff12f455164b771b477961d5e1690a118f62fc0d4bbf905de1bf4818b5"
    sha256 cellar: :any_skip_relocation, monterey:       "54001eff12f455164b771b477961d5e1690a118f62fc0d4bbf905de1bf4818b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ae46ff7920ec50d2a0e4a5236c6a5af607338b0f24a78a3b61e0d6af962cc0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5729d439b77dd7f2fe7ba6cff95d82322d62940634b93eb6109f854d9e320bd9"
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
