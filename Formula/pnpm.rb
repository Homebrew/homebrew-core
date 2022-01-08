class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.25.1.tgz"
  sha256 "58cc71d201039af75dd43d36f166e36da9843014e2c17d697b12c5c2662265fa"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a0dbcdf2c7fd8d3bab695c855ed27542b69320d44875df59fd8865e280664ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0dbcdf2c7fd8d3bab695c855ed27542b69320d44875df59fd8865e280664ed"
    sha256 cellar: :any_skip_relocation, monterey:       "582a37529c16fc8d37f978714532788b2e621afd4190588358c67297fbe7a170"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5b9bf092c87eb04b658472fbc14ba572cea0ba9f0a9c6953e1e9aa45dc8ea3f"
    sha256 cellar: :any_skip_relocation, catalina:       "e5b9bf092c87eb04b658472fbc14ba572cea0ba9f0a9c6953e1e9aa45dc8ea3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a0dbcdf2c7fd8d3bab695c855ed27542b69320d44875df59fd8865e280664ed"
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
