class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.13.1.tgz"
  sha256 "e641f4de1b30ffff2d6c235f9bfe7db3ccd07584b446482c9578b51a99231668"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc8a9b47482d8b5fdce47d4a49fbd90eaeb251d795028dd265d321eec4939ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc8a9b47482d8b5fdce47d4a49fbd90eaeb251d795028dd265d321eec4939ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "5c63e9a50d848d8185ce3899aedd6df5941c9dac99c460b60ac382a94dddeb25"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b4d4ea18f312207270b0cd8a4c609846ffa70355ce3594b1cd0b32ba34cfb25"
    sha256 cellar: :any_skip_relocation, catalina:       "2b4d4ea18f312207270b0cd8a4c609846ffa70355ce3594b1cd0b32ba34cfb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8a9b47482d8b5fdce47d4a49fbd90eaeb251d795028dd265d321eec4939ae2"
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
