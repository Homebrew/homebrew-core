class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.9.0.tgz"
  sha256 "f474fe002ffbc3651504e9815257e73b52c553ebb04e4fd79257de6042260a3a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e05c26a6cd80626904089557d908ce6b7795c2f61e8d1e69e2211035a344e08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e05c26a6cd80626904089557d908ce6b7795c2f61e8d1e69e2211035a344e08a"
    sha256 cellar: :any_skip_relocation, monterey:       "5052b221b4430f3fb18114e61e2427e9934bccf89dfb454ef7eb42022f14b6bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "699a0f7d8ebf6c2f921820d79f0f4aa2a9eeb8964b3aac4893c1ad693fa9e0ca"
    sha256 cellar: :any_skip_relocation, catalina:       "699a0f7d8ebf6c2f921820d79f0f4aa2a9eeb8964b3aac4893c1ad693fa9e0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e05c26a6cd80626904089557d908ce6b7795c2f61e8d1e69e2211035a344e08a"
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
