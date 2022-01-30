class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.29.0.tgz"
  sha256 "50fc7a66431c83030f8c37dd3eb586e5401676e5b0bbe6314d3c167bfa67f1ba"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "565cc36a8ebbfa50270ca256f38c592bf41c8c6da099c2307118911e1cf57e2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "565cc36a8ebbfa50270ca256f38c592bf41c8c6da099c2307118911e1cf57e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "4f20a9de10a17880e66c1c003aa0f24e87632cf9c96124a04b48c9f8a299987a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7162b5e06bb1a786ec59576d3206894c62d9ae8130c154119a226ca89a780858"
    sha256 cellar: :any_skip_relocation, catalina:       "7162b5e06bb1a786ec59576d3206894c62d9ae8130c154119a226ca89a780858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "565cc36a8ebbfa50270ca256f38c592bf41c8c6da099c2307118911e1cf57e2c"
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
