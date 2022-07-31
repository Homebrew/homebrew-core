class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.7.1.tgz"
  sha256 "02ab392c38e6a7a170d7e1f0ecf590ac544ed04d5c6d20ff727c329f04988a18"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3c04544aeea78799dc8026d3ae8dcabe52f99e5986682470ecd6961c4e6ca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b3c04544aeea78799dc8026d3ae8dcabe52f99e5986682470ecd6961c4e6ca8"
    sha256 cellar: :any_skip_relocation, monterey:       "9d31d87664bc3023d5b62b8d56a0d7b9fb8df2e0ceac075133d7678a56c8516f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5851b44dd55b12ccdce50223bea5b09ee485ed0eba625dd65555aa8237a0a352"
    sha256 cellar: :any_skip_relocation, catalina:       "5851b44dd55b12ccdce50223bea5b09ee485ed0eba625dd65555aa8237a0a352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3c04544aeea78799dc8026d3ae8dcabe52f99e5986682470ecd6961c4e6ca8"
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
