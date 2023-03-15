class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.29.3.tgz"
  sha256 "389f1925065d8e9a5575efdb3bf1c7fd3a14b20778e77aafdfb961588c765801"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0e1225e444583f7c17154cc72788889407dced9c1b3c84dd5b670e43ed7d241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e1225e444583f7c17154cc72788889407dced9c1b3c84dd5b670e43ed7d241"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0e1225e444583f7c17154cc72788889407dced9c1b3c84dd5b670e43ed7d241"
    sha256 cellar: :any_skip_relocation, ventura:        "c51dcbc97bca786720fce1636cd3e7315cb92b0996dfe27dfad14d700fc3d9cd"
    sha256 cellar: :any_skip_relocation, monterey:       "c51dcbc97bca786720fce1636cd3e7315cb92b0996dfe27dfad14d700fc3d9cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "2635a15aa215e0656a3ba06a0bd6a99f38b9a8a0fc4110946d1830825a4f672e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e1225e444583f7c17154cc72788889407dced9c1b3c84dd5b670e43ed7d241"
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
