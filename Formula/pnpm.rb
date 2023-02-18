class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.27.1.tgz"
  sha256 "8cd593de4963fd6da69bd658fe1bd1944438bf82ee2d2e80bf3c46fcb93c979f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e82cc3c5e7942f80df18c405834cd31e65aa43013668932b542a885fee74b39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8276e154b7b341a6890519ad2a06e57277765dc70cbac688a0cda1391fbdf211"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22c17b6cecf3b16e23d75b84d91ad557594e0cf8f66942f3a10dedba5531aa2f"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0b95cd202f3a8ea0c203f30f037de1f7d32950a00a277936c9179525ea5217"
    sha256 cellar: :any_skip_relocation, monterey:       "10274adce518ec846e780c8ce58d1aa588643f952afafa69d7ce5291007a0be1"
    sha256 cellar: :any_skip_relocation, big_sur:        "55eb2f093da47de41a3ec34011e62b390aeb361f7bb499a907c7a6f0e8c05705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b65936dbd12683f81b4513a883ab45cba8a0c9cb533bd19eb4da7d8bcae284ce"
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
