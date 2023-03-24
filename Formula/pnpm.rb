class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.30.3.tgz"
  sha256 "0b16a177ad19c0ffdc2bf24f960534400fec2e6d7ef05a70b65b43a9b57e7f1b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c062f2aeeef4bf0c0e218f8c65334cd947ef874669d763624b6f19de31421891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c062f2aeeef4bf0c0e218f8c65334cd947ef874669d763624b6f19de31421891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c062f2aeeef4bf0c0e218f8c65334cd947ef874669d763624b6f19de31421891"
    sha256 cellar: :any_skip_relocation, ventura:        "52f8ee13aa8b3461de474fd8b156f41dc26653053e1dff91edb4895a0d01845a"
    sha256 cellar: :any_skip_relocation, monterey:       "52f8ee13aa8b3461de474fd8b156f41dc26653053e1dff91edb4895a0d01845a"
    sha256 cellar: :any_skip_relocation, big_sur:        "24d4e85a23aa92b0e0597844086e39698783f1c98691a9bbd7a0d133ed79ad85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c062f2aeeef4bf0c0e218f8c65334cd947ef874669d763624b6f19de31421891"
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
