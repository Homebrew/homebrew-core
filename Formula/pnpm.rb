class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.9.1.tgz"
  sha256 "9031367b1dbb8f83ed7e62f0b6785e3c1d103f6738ef8f619f14edcccd24a04a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5b0cad4307a1da4a0f36e02925ed4e6513a7c2e6c840d847f957482f54d3e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5b0cad4307a1da4a0f36e02925ed4e6513a7c2e6c840d847f957482f54d3e65"
    sha256 cellar: :any_skip_relocation, monterey:       "4f14706f5163a4e8a42e506c96fa688c218860d5ce38080012a15b341e33b835"
    sha256 cellar: :any_skip_relocation, big_sur:        "595f025cff1a967dff48737bba646f8113ca8507b76c8253a6840fda0e2cc619"
    sha256 cellar: :any_skip_relocation, catalina:       "595f025cff1a967dff48737bba646f8113ca8507b76c8253a6840fda0e2cc619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b0cad4307a1da4a0f36e02925ed4e6513a7c2e6c840d847f957482f54d3e65"
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
