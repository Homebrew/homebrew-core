class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.16.1.tgz"
  sha256 "843ecd1e70f627c2a2071b5b7c7b1920576665d23344f145c557a847df72eb58"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23ebff672c4979d3b9eade0206813fdcd8b1840b670cc6dd3b8a452c2ce04547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ebff672c4979d3b9eade0206813fdcd8b1840b670cc6dd3b8a452c2ce04547"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23ebff672c4979d3b9eade0206813fdcd8b1840b670cc6dd3b8a452c2ce04547"
    sha256 cellar: :any_skip_relocation, ventura:        "0813e7a24029e13e09623081ea051400e57b3f03296c307801159cb9322720d5"
    sha256 cellar: :any_skip_relocation, monterey:       "0813e7a24029e13e09623081ea051400e57b3f03296c307801159cb9322720d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3fc873621b1ceffcd29d1f1ff815fbc76eef8ba7a8407e4df83950e36e0cb98"
    sha256 cellar: :any_skip_relocation, catalina:       "f3fc873621b1ceffcd29d1f1ff815fbc76eef8ba7a8407e4df83950e36e0cb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ebff672c4979d3b9eade0206813fdcd8b1840b670cc6dd3b8a452c2ce04547"
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
