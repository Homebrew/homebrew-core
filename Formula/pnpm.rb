class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.7.tgz"
  sha256 "6e823446a31b38f87e8bb9dd3437a0537eb49a9d7b19813b9f81c88b100c3d07"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18ba30779240c6dbf15a9849ef06e527b3305f9fd79da8d02d5aacf39490c2f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "ccf0d0bf541457b0512762a4cd6e64b7fb04d75895955c927c4926b78cac5465"
    sha256 cellar: :any_skip_relocation, catalina:      "ccf0d0bf541457b0512762a4cd6e64b7fb04d75895955c927c4926b78cac5465"
    sha256 cellar: :any_skip_relocation, mojave:        "ccf0d0bf541457b0512762a4cd6e64b7fb04d75895955c927c4926b78cac5465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ba30779240c6dbf15a9849ef06e527b3305f9fd79da8d02d5aacf39490c2f0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
