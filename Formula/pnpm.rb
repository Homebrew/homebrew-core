class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.14.1.tgz"
  sha256 "a577ae0336a23c21519db73440170f5a83affb19cc36fea4af2c2aeefcd9d23c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f591591c602ff25b74ffac107dcd7e6a35b2e5f41cf9041673b2a4d05fc59b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86f591591c602ff25b74ffac107dcd7e6a35b2e5f41cf9041673b2a4d05fc59b"
    sha256 cellar: :any_skip_relocation, monterey:       "87644073b2f1d1a45498592f8e587226ea6a28731c21181f66682d44bfe76c3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "97984682e075ef027894dabe7ec0c909a603214131f0dd378cc81dbcc6bff487"
    sha256 cellar: :any_skip_relocation, catalina:       "97984682e075ef027894dabe7ec0c909a603214131f0dd378cc81dbcc6bff487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f591591c602ff25b74ffac107dcd7e6a35b2e5f41cf9041673b2a4d05fc59b"
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
