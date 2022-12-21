class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.19.0.tgz"
  sha256 "cd9f57162f347405061f3a1e43bf01268640a742cd51c54c32ee06bc7e3d5e0f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54fc94b45df0dcc3c1793518c9182ca7f8de8ea6e912c7903bf5e5185d07de76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54fc94b45df0dcc3c1793518c9182ca7f8de8ea6e912c7903bf5e5185d07de76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54fc94b45df0dcc3c1793518c9182ca7f8de8ea6e912c7903bf5e5185d07de76"
    sha256 cellar: :any_skip_relocation, ventura:        "7c6f59dff5f2e87170384e2876f99cb76bd65c78a39df080ee65de62d2bf65e6"
    sha256 cellar: :any_skip_relocation, monterey:       "7c6f59dff5f2e87170384e2876f99cb76bd65c78a39df080ee65de62d2bf65e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b0991f83f0506e26e7c6d6e75edb7c47dda2dde3ba5efbe117781044ef8eaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fc94b45df0dcc3c1793518c9182ca7f8de8ea6e912c7903bf5e5185d07de76"
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
