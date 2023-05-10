class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.5.0.tgz"
  sha256 "b013403809dc950d169f16423b74e9b6c749f6934adb067abe90e9a16b89935f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57133fb84d6f1926b569b9ef86cccad35ea32e7de1089215a8dd7dcbf6b849d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57133fb84d6f1926b569b9ef86cccad35ea32e7de1089215a8dd7dcbf6b849d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57133fb84d6f1926b569b9ef86cccad35ea32e7de1089215a8dd7dcbf6b849d4"
    sha256 cellar: :any_skip_relocation, ventura:        "76e9f91b8038d2f379bbe25335c1014139c2b13cec5de0d3461e3c7a534486b8"
    sha256 cellar: :any_skip_relocation, monterey:       "76e9f91b8038d2f379bbe25335c1014139c2b13cec5de0d3461e3c7a534486b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "119401609d1657706acafa0cb7d0477cc730058fa32fef7f6bd3da71a8f9edf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57133fb84d6f1926b569b9ef86cccad35ea32e7de1089215a8dd7dcbf6b849d4"
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
