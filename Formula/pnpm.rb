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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16695e17c10aaaaa02c071c6ced42ee1854b08e4be6f5bd796a6b14534dd26e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c16695e17c10aaaaa02c071c6ced42ee1854b08e4be6f5bd796a6b14534dd26e"
    sha256 cellar: :any_skip_relocation, monterey:       "d12bf7d4a2f1300e3312b76c232544277d34d98b60e9a69e63f5bcb424dee05e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20d6baefbfef2e8962cadd8b29c75a57e7fa1eda7989919d83a43c57e42db17"
    sha256 cellar: :any_skip_relocation, catalina:       "b20d6baefbfef2e8962cadd8b29c75a57e7fa1eda7989919d83a43c57e42db17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16695e17c10aaaaa02c071c6ced42ee1854b08e4be6f5bd796a6b14534dd26e"
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
