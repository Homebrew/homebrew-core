class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.2.1.tgz"
  sha256 "c5fb3e8e09c78887dddd91bc5b3465fe298fb50ac796f9a45e560b2d69a717ea"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "182852149f1d8aa8ba167fff84fc8a142bf330807a5b2848a080943bdf392902"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "182852149f1d8aa8ba167fff84fc8a142bf330807a5b2848a080943bdf392902"
    sha256 cellar: :any_skip_relocation, monterey:       "377e5e48df74d625573492bd04de006fa68f2d7d4e556597c4390a6d8c1006dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "25cf228c8caa6b8647dcd58376710c6c9774b41bc0dc0479b15509195deda0a1"
    sha256 cellar: :any_skip_relocation, catalina:       "25cf228c8caa6b8647dcd58376710c6c9774b41bc0dc0479b15509195deda0a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182852149f1d8aa8ba167fff84fc8a142bf330807a5b2848a080943bdf392902"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
