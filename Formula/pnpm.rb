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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f806b840aedd1d701bc0f2b6c5acc2e47c88c29be1bd911cf12056e76a53020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f806b840aedd1d701bc0f2b6c5acc2e47c88c29be1bd911cf12056e76a53020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f806b840aedd1d701bc0f2b6c5acc2e47c88c29be1bd911cf12056e76a53020"
    sha256 cellar: :any_skip_relocation, ventura:        "0e72705aa0c9100b9afe90ea3ce92c1bf767286c50ecc37ed86df635eced1917"
    sha256 cellar: :any_skip_relocation, monterey:       "0e72705aa0c9100b9afe90ea3ce92c1bf767286c50ecc37ed86df635eced1917"
    sha256 cellar: :any_skip_relocation, big_sur:        "82e1b846f4c33fa23fd7f41cb23c07821bc2817225212094318d07f3938b50e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f806b840aedd1d701bc0f2b6c5acc2e47c88c29be1bd911cf12056e76a53020"
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
