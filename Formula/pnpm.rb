class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.29.2.tgz"
  sha256 "ca84a527d049211318ec9bdae7598dd1c18e9fdcc29c5071f04ea45fb9ca0e25"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe58c541282d75de3cb0fdc30b69ac5c22ca1b5f448dd27e17878d132b735617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe58c541282d75de3cb0fdc30b69ac5c22ca1b5f448dd27e17878d132b735617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe58c541282d75de3cb0fdc30b69ac5c22ca1b5f448dd27e17878d132b735617"
    sha256 cellar: :any_skip_relocation, ventura:        "b1137392c0c4e3bb97a450245878bc33422638f181328906a5e4c8792b78b38f"
    sha256 cellar: :any_skip_relocation, monterey:       "b1137392c0c4e3bb97a450245878bc33422638f181328906a5e4c8792b78b38f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b733aa6889ba0deec8d26d18860187f99236175b5ae2c8f4390066b4d22eec44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe58c541282d75de3cb0fdc30b69ac5c22ca1b5f448dd27e17878d132b735617"
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
