class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.11.tgz"
  sha256 "38f9d94a8151ac80c429000d02ba7a0573e07e45eaeffc59ff0ab70c4b2a7da8"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd12fd982428a06c27275627dcdbd8b6dbf7392c4351dbeacbc6f9598466850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd12fd982428a06c27275627dcdbd8b6dbf7392c4351dbeacbc6f9598466850"
    sha256 cellar: :any_skip_relocation, monterey:       "d6c5ebbc4a0497ff8b2113f2ed9cef6fc4c28f5d8947b228d78e6f33433f3e6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0acdf93d475bbb6443a63b2e80e73ba56dd678fedc1769d65b25b5b1b4b94c32"
    sha256 cellar: :any_skip_relocation, catalina:       "0acdf93d475bbb6443a63b2e80e73ba56dd678fedc1769d65b25b5b1b4b94c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd12fd982428a06c27275627dcdbd8b6dbf7392c4351dbeacbc6f9598466850"
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
