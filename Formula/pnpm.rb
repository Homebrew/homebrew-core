class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.17.0.tgz"
  sha256 "0569c3da6c6a849c15a00b7d4468ae35694c9112fd9304ebb34f7fc3959aad8c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a6290a6b7930613f46cb371e86bbbb3b2259fcdafe4c0e3bd11a30ccaa45ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58a6290a6b7930613f46cb371e86bbbb3b2259fcdafe4c0e3bd11a30ccaa45ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58a6290a6b7930613f46cb371e86bbbb3b2259fcdafe4c0e3bd11a30ccaa45ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e2113210f19e100d773dcad6819eb9ad8f8455ba9a192703d07e84cabe692604"
    sha256 cellar: :any_skip_relocation, big_sur:        "9977add09e3896295717a104891973ba0b38289044ca6e9b1c0423335ebc7a54"
    sha256 cellar: :any_skip_relocation, catalina:       "9977add09e3896295717a104891973ba0b38289044ca6e9b1c0423335ebc7a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a6290a6b7930613f46cb371e86bbbb3b2259fcdafe4c0e3bd11a30ccaa45ef"
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
