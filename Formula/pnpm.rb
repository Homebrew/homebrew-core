class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.10.tgz"
  sha256 "03fef321385d2d0e7931ffe01fece71c3b9808028a65f810cd7bb35f1f2408eb"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4b1f8059c2393b07fb0a3ff929ae6c09be6db7819adfd08c47a0a686f49886"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be4b1f8059c2393b07fb0a3ff929ae6c09be6db7819adfd08c47a0a686f49886"
    sha256 cellar: :any_skip_relocation, monterey:       "92abd11f8fb1944dcbff4a7308bccbd78f2fe14092d59f90424f743e6de76043"
    sha256 cellar: :any_skip_relocation, big_sur:        "a739d23b84253ebef588cdd61a34159bd050667171cecf2332723b71895043dc"
    sha256 cellar: :any_skip_relocation, catalina:       "a739d23b84253ebef588cdd61a34159bd050667171cecf2332723b71895043dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be4b1f8059c2393b07fb0a3ff929ae6c09be6db7819adfd08c47a0a686f49886"
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
