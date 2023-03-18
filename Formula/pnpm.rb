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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc9fb7d006f8bcdb1989b77deda65913845137e7de0ded4a2d6feb1627227192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc9fb7d006f8bcdb1989b77deda65913845137e7de0ded4a2d6feb1627227192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc9fb7d006f8bcdb1989b77deda65913845137e7de0ded4a2d6feb1627227192"
    sha256 cellar: :any_skip_relocation, ventura:        "c6aad0fd4d8b6ecc19f492365c8af417ddea279e5b68ed13b1b16ab333f1fae2"
    sha256 cellar: :any_skip_relocation, monterey:       "c6aad0fd4d8b6ecc19f492365c8af417ddea279e5b68ed13b1b16ab333f1fae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4cbe7fe4223bfbb952422498e073ec1eb3d1c2a7899e7d8d470397289a5011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc9fb7d006f8bcdb1989b77deda65913845137e7de0ded4a2d6feb1627227192"
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
