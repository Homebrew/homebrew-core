class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.6.tgz"
  sha256 "4f175b9df8c2fd68d8843caafd69e86c3349581794481ec9b6333357f4743713"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3c779ce0dfc5bb87b03f5797369f737e659a6bc12ec208bb861c6d60760efb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff3c779ce0dfc5bb87b03f5797369f737e659a6bc12ec208bb861c6d60760efb"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9b4ec4e14c779fddc936d5c384045ecebfc347b45a8b97639a4af84676d4ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcb47e3cc9a28a6546d3b3d6d38ff11b3a8736f1edbdfdf7b99305d02c3a9b27"
    sha256 cellar: :any_skip_relocation, catalina:       "fcb47e3cc9a28a6546d3b3d6d38ff11b3a8736f1edbdfdf7b99305d02c3a9b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3c779ce0dfc5bb87b03f5797369f737e659a6bc12ec208bb861c6d60760efb"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
