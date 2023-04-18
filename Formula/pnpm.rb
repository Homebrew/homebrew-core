class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.3.0.tgz"
  sha256 "784bd9287f52dac158cc04f99e5d9f5e9b80e4ea0553fe5a2d755e8bbbd64896"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b456afb6c7f92ba7d1dc92ff17fa3c50f98b49d7e450c976748ea9583de52e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b456afb6c7f92ba7d1dc92ff17fa3c50f98b49d7e450c976748ea9583de52e2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b456afb6c7f92ba7d1dc92ff17fa3c50f98b49d7e450c976748ea9583de52e2a"
    sha256 cellar: :any_skip_relocation, ventura:        "7cb45043f26cd33bed3ccd5050b09af93f153e1b4649af62e6bc6f1625d9c0d5"
    sha256 cellar: :any_skip_relocation, monterey:       "7cb45043f26cd33bed3ccd5050b09af93f153e1b4649af62e6bc6f1625d9c0d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2522dcdcca14a0430f164783006911f837ee5e1c72d2540a912613e61a8597ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b456afb6c7f92ba7d1dc92ff17fa3c50f98b49d7e450c976748ea9583de52e2a"
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
