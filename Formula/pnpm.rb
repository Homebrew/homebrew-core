class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.10.0.tgz"
  sha256 "d94ac7235367b88bdf7abfd6a850fcf864944bd9a72aa76087278736bb5b7c43"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cec8ef672f1751787fe68a598c3c94504c076c1dd9ef565082c43554bdb7a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cec8ef672f1751787fe68a598c3c94504c076c1dd9ef565082c43554bdb7a78"
    sha256 cellar: :any_skip_relocation, monterey:       "e665b08f01eb5a8808ca26844ac61f468c896308cd863a6a2220eba5887f262b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c52ffeb4bfbb848d97826212efe334950fa5b7899591cc74ca2bf29911593c5c"
    sha256 cellar: :any_skip_relocation, catalina:       "c52ffeb4bfbb848d97826212efe334950fa5b7899591cc74ca2bf29911593c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cec8ef672f1751787fe68a598c3c94504c076c1dd9ef565082c43554bdb7a78"
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
