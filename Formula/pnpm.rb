class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.8.0.tgz"
  sha256 "55a63681c16a9c0a1958e0adfc3ed09e478f1e9258cbd07251a0d7a5b28899a4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4825004fe840f64cd4e68df8e52cf08811ba2e2b9bc0a6588498f1f62008c5af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4825004fe840f64cd4e68df8e52cf08811ba2e2b9bc0a6588498f1f62008c5af"
    sha256 cellar: :any_skip_relocation, monterey:       "76f30b439c123a475a804444ad9dd7595ba0db0d03596e9c7626158f23350a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "885826a41aead39075fc73652c9ff0654eec2433cae33c3dba38296b8fe6e604"
    sha256 cellar: :any_skip_relocation, catalina:       "885826a41aead39075fc73652c9ff0654eec2433cae33c3dba38296b8fe6e604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4825004fe840f64cd4e68df8e52cf08811ba2e2b9bc0a6588498f1f62008c5af"
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
