class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.0.1.tgz"
  sha256 "ae0d84c718ec141f7419c23a43bc4c1f42114e846d9af3042826f8d6a553d711"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b73a4779a22f765f8322b8bbf2bd0625422513d4473e7567c837198b984908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35b73a4779a22f765f8322b8bbf2bd0625422513d4473e7567c837198b984908"
    sha256 cellar: :any_skip_relocation, monterey:       "800a871b1d8d9e7e69f4973b359af2da95d4a8cc3180f6cb2aa6d29d7c7ca42b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3b6192d05983f3f54faeb111ce50b1e355bbc8fae1477892e35d81e5f53b1b7"
    sha256 cellar: :any_skip_relocation, catalina:       "b3b6192d05983f3f54faeb111ce50b1e355bbc8fae1477892e35d81e5f53b1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35b73a4779a22f765f8322b8bbf2bd0625422513d4473e7567c837198b984908"
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
