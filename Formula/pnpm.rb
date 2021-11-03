class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.20.1.tgz"
  sha256 "185e6199d9b7ba30d2a4129776eecbb82d78046616ea94b5a839044451b1a271"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94a8842b2a8c163ed990a478415ab6f5b8e266d9b655d200db8eab054e958009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94a8842b2a8c163ed990a478415ab6f5b8e266d9b655d200db8eab054e958009"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf27ef89fe94b4952c1603af28aa7d80ee38303312f42ad9605611832d4f36b"
    sha256 cellar: :any_skip_relocation, big_sur:        "247cb73f7019ce6b1d48c809caf0f83311bec6f8151a733eaba6ac67cb4d9a74"
    sha256 cellar: :any_skip_relocation, catalina:       "247cb73f7019ce6b1d48c809caf0f83311bec6f8151a733eaba6ac67cb4d9a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a8842b2a8c163ed990a478415ab6f5b8e266d9b655d200db8eab054e958009"
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
