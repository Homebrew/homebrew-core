class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.4.0.tgz"
  sha256 "9c70e157619e6b956d08ae3f69be00d67b191529b943cadd200254f4d1d18b98"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa4d9945568d5f0d58cb083b7adad54e13bed26520f040c810a04b20003015e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fa4d9945568d5f0d58cb083b7adad54e13bed26520f040c810a04b20003015e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ca0e18ea66f6de76f7352064781ad84b2fca21ee28cfe08b493bb3a131c7df"
    sha256 cellar: :any_skip_relocation, big_sur:        "7336ded6b281bc0306c8e5614ab10e73a246e1b8ae2bf83cbe90cf7281995158"
    sha256 cellar: :any_skip_relocation, catalina:       "7336ded6b281bc0306c8e5614ab10e73a246e1b8ae2bf83cbe90cf7281995158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa4d9945568d5f0d58cb083b7adad54e13bed26520f040c810a04b20003015e"
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
