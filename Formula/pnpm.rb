class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.20.2.tgz"
  sha256 "d314cad0cd1eb4c13e2cb2502c9adb53ec69d2bf907a59403fa6f4c5332501d0"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e7a1f4a6c9ac6ab3ad2196e33b6a5cdd61745dd618ebcad1217c87dd236973f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e7a1f4a6c9ac6ab3ad2196e33b6a5cdd61745dd618ebcad1217c87dd236973f"
    sha256 cellar: :any_skip_relocation, monterey:       "3ba4ceb8b5c2702bdcb0fac624619ce9bcb8773066e0da0f4009fac89b2feb9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6de0105c973d38d6091b1bdef3e83fbe9577e7c21304c1dde5f87a5eba758bb8"
    sha256 cellar: :any_skip_relocation, catalina:       "6de0105c973d38d6091b1bdef3e83fbe9577e7c21304c1dde5f87a5eba758bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e7a1f4a6c9ac6ab3ad2196e33b6a5cdd61745dd618ebcad1217c87dd236973f"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
