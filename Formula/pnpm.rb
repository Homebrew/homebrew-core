class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.8.tgz"
  sha256 "75b8fbff75b02d8c51ca7f24f3e8ac05fc0307e7afa78c0b8ee0ada7ec230404"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24fc92011a665ad38e5d0fb6e0d738ce4b79cb7e6a1cf1f262d081f9a06d9ab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24fc92011a665ad38e5d0fb6e0d738ce4b79cb7e6a1cf1f262d081f9a06d9ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb08b69ae77c405a0bfc36d591cb00ee5af7e2a22ca4ab1903d02caea631819"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd78c228b3f735b08af91c6c8d9e6da2c455bf59d9aca31f8dd14322b6c1a7c"
    sha256 cellar: :any_skip_relocation, catalina:       "6cd78c228b3f735b08af91c6c8d9e6da2c455bf59d9aca31f8dd14322b6c1a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fc92011a665ad38e5d0fb6e0d738ce4b79cb7e6a1cf1f262d081f9a06d9ab3"
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
