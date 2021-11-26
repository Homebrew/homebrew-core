class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.23.2.tgz"
  sha256 "33de7b61ecf516ec5be36cf783520b5532ecfa54f36d3229a7a4d314b7137ee7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5952dc9874f5f9717622df9adb62ffcc805f98ba5d4f7fe74cba392aec02ddb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5952dc9874f5f9717622df9adb62ffcc805f98ba5d4f7fe74cba392aec02ddb9"
    sha256 cellar: :any_skip_relocation, monterey:       "c757536f2f401a1f295e247b6d8e9c32dd4124d434dbeae57293e21510b9d311"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fda6e26e0bbb99ca5bac7de749e7301f7a10e6129fe7b091bb440ef85cebbcd"
    sha256 cellar: :any_skip_relocation, catalina:       "8fda6e26e0bbb99ca5bac7de749e7301f7a10e6129fe7b091bb440ef85cebbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5952dc9874f5f9717622df9adb62ffcc805f98ba5d4f7fe74cba392aec02ddb9"
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
