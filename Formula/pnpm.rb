class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.9.tgz"
  sha256 "19c9a02c4385af09988e1db968832244407d4d97e09d9dc8b6183bd25fcc3288"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5b73d5b530b68360da3d295542093c9b02a068aad775d4afe79dc76ededd448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5b73d5b530b68360da3d295542093c9b02a068aad775d4afe79dc76ededd448"
    sha256 cellar: :any_skip_relocation, monterey:       "40d43870fa72f01cd59c1dd8ffc710483e2ba8e9931f7ee74e7496689c388d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd401b775efe77b7e07c3d78321fccd47ea53c24440a5e14a0cbf85f2823b4f5"
    sha256 cellar: :any_skip_relocation, catalina:       "fd401b775efe77b7e07c3d78321fccd47ea53c24440a5e14a0cbf85f2823b4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b73d5b530b68360da3d295542093c9b02a068aad775d4afe79dc76ededd448"
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
