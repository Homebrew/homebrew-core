class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.13.1.tgz"
  sha256 "e641f4de1b30ffff2d6c235f9bfe7db3ccd07584b446482c9578b51a99231668"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17a8003e332d4d4b01278022c6c0e4d3886c9cb21e58d8b5c585db1e0886166c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17a8003e332d4d4b01278022c6c0e4d3886c9cb21e58d8b5c585db1e0886166c"
    sha256 cellar: :any_skip_relocation, monterey:       "3accb27ad2934d42a5561bbd2ccb37c0629ddd36f21812cd08f6fc3cd8184ac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac539a43c3238d1c8021474f69e372a6b16bb2c600608afb84573c8d20d07ca9"
    sha256 cellar: :any_skip_relocation, catalina:       "ac539a43c3238d1c8021474f69e372a6b16bb2c600608afb84573c8d20d07ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a8003e332d4d4b01278022c6c0e4d3886c9cb21e58d8b5c585db1e0886166c"
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
