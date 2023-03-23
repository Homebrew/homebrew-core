class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.30.1.tgz"
  sha256 "3ac5c0bd44181f6bd68f7a968986a5879ac860d7cfa5df3449b4a1e2593d9e01"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04508f9adc5ff32ac52be138f853de26742b5a7a9438748ceff0477e8d1271af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04508f9adc5ff32ac52be138f853de26742b5a7a9438748ceff0477e8d1271af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04508f9adc5ff32ac52be138f853de26742b5a7a9438748ceff0477e8d1271af"
    sha256 cellar: :any_skip_relocation, ventura:        "e163db2590e48299a7494f525b0a9d6183795cd77a8049f652db35b748d879bb"
    sha256 cellar: :any_skip_relocation, monterey:       "e163db2590e48299a7494f525b0a9d6183795cd77a8049f652db35b748d879bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a6e88b6cbab5ec765d4dd689c081b91f30713dc7010df26dc1206a6d072b5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04508f9adc5ff32ac52be138f853de26742b5a7a9438748ceff0477e8d1271af"
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
