class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.12.1.tgz"
  sha256 "4037e78e0ec637e90c86ed5765cd4409c3deb0a6ca2a9864b202bb957e328ed9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7da2aca6833071eec6626c22e5026af7587cd297ce324d49b4f3bdffb60ea8ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "a82c695979562329a3b6bfe645c59d8cbf8708ff65d95ad6704bfaa023f1ce60"
    sha256 cellar: :any_skip_relocation, catalina:      "a82c695979562329a3b6bfe645c59d8cbf8708ff65d95ad6704bfaa023f1ce60"
    sha256 cellar: :any_skip_relocation, mojave:        "a82c695979562329a3b6bfe645c59d8cbf8708ff65d95ad6704bfaa023f1ce60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da2aca6833071eec6626c22e5026af7587cd297ce324d49b4f3bdffb60ea8ee"
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
