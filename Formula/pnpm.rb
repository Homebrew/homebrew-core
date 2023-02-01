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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bd4a6ae06786a509c73241a05aee3971c4c268ce4b012f81100760b8248b696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd4a6ae06786a509c73241a05aee3971c4c268ce4b012f81100760b8248b696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bd4a6ae06786a509c73241a05aee3971c4c268ce4b012f81100760b8248b696"
    sha256 cellar: :any_skip_relocation, ventura:        "93eb04bdc7506542023c81003ab1efa09b6f748235ad0c2ec0d34ac7abb2cfd6"
    sha256 cellar: :any_skip_relocation, monterey:       "93eb04bdc7506542023c81003ab1efa09b6f748235ad0c2ec0d34ac7abb2cfd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c53c2d798d88fc5176502bb90971e65a854f2b0a615294cbc41333fdf7a0c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd4a6ae06786a509c73241a05aee3971c4c268ce4b012f81100760b8248b696"
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
