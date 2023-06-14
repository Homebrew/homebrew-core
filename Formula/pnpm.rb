class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.2.tgz"
  sha256 "c6da9e00697e334b6193c034a5d1508e4c8605b12f249736b13f31139f4f0d73"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba06fbecf02ab23df9c8f2c1ae8860a1c7dd8299f375a0f12d2538fd07219d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fba06fbecf02ab23df9c8f2c1ae8860a1c7dd8299f375a0f12d2538fd07219d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fba06fbecf02ab23df9c8f2c1ae8860a1c7dd8299f375a0f12d2538fd07219d2"
    sha256 cellar: :any_skip_relocation, ventura:        "7c2466ce64fd72f44f0a1a034052409edac871a531480ccd4efb1fed3fe70be1"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2466ce64fd72f44f0a1a034052409edac871a531480ccd4efb1fed3fe70be1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7389f99544279cd5cfecb9503cc9cf6f970686c8f25dcdf49788a1eb42f0499c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba06fbecf02ab23df9c8f2c1ae8860a1c7dd8299f375a0f12d2538fd07219d2"
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
