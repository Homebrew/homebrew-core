class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.24.2.tgz"
  sha256 "d451099d8d532b178e485e2a96e507135159b0228052c0dda899f92f0297225c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d9f8185ddbb85437e43b7b33475c5991dbbbb998991eff49b2cef7bcf4f0ca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d9f8185ddbb85437e43b7b33475c5991dbbbb998991eff49b2cef7bcf4f0ca8"
    sha256 cellar: :any_skip_relocation, monterey:       "f942f62304e5d54053862221674c1a734c94233c9d48af340f90024a7cf366a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3bdcf0762cd93bf3a1c754330eb14bd09e2b7e7ba6d3228927a5682f110b0e"
    sha256 cellar: :any_skip_relocation, catalina:       "de3bdcf0762cd93bf3a1c754330eb14bd09e2b7e7ba6d3228927a5682f110b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9f8185ddbb85437e43b7b33475c5991dbbbb998991eff49b2cef7bcf4f0ca8"
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
