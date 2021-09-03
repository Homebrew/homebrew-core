class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.6.tgz"
  sha256 "b4d628b12fd3fd6f6f74a3e1ef08783b64dadce101797ee75de0ae6d4f14e154"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1ba68afea92596b8719e6ffb10af76e1e7026aafb88034bd7d8cab3b605b0d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c799e842ae330add2d5862b7f6ee11371fb823fd242f25bc53b059977ef9e8cf"
    sha256 cellar: :any_skip_relocation, catalina:      "c799e842ae330add2d5862b7f6ee11371fb823fd242f25bc53b059977ef9e8cf"
    sha256 cellar: :any_skip_relocation, mojave:        "c799e842ae330add2d5862b7f6ee11371fb823fd242f25bc53b059977ef9e8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ba68afea92596b8719e6ffb10af76e1e7026aafb88034bd7d8cab3b605b0d7"
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
