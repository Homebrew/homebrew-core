class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.14.0.tgz"
  sha256 "2b698f0e6bb9eca3e50efbc43311e0fb6b3295af93046892e4ee41b9b0e3bff9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83056d51bbb879b3858d2841e9bc1f5aeb0dc7a10fdf34a7933fb09bfe83bbc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83056d51bbb879b3858d2841e9bc1f5aeb0dc7a10fdf34a7933fb09bfe83bbc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83056d51bbb879b3858d2841e9bc1f5aeb0dc7a10fdf34a7933fb09bfe83bbc9"
    sha256 cellar: :any_skip_relocation, monterey:       "1e933118d5e96270eed8aa6bd7506cd512d6707a0d0557ed54dff18950f98950"
    sha256 cellar: :any_skip_relocation, big_sur:        "859751fa88a11e9c777f21dcecb45a7739664f70b6b0d0819650ee54c390644c"
    sha256 cellar: :any_skip_relocation, catalina:       "859751fa88a11e9c777f21dcecb45a7739664f70b6b0d0819650ee54c390644c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83056d51bbb879b3858d2841e9bc1f5aeb0dc7a10fdf34a7933fb09bfe83bbc9"
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
