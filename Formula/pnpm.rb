class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.19.1.tgz"
  sha256 "c3cdaafab9eb6d3a41e6c4e0deef0ed942a80dce92911410158c5d8c39f7a21e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66cbd78fb3559f26e9ca247003905ac6286dc0f138a3ae01fc4dc3a94311b1ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66cbd78fb3559f26e9ca247003905ac6286dc0f138a3ae01fc4dc3a94311b1ca"
    sha256 cellar: :any_skip_relocation, monterey:       "9b17349746ce11cbd5c52065bbc242dc1241a78e2521ca75bece9a13290f8d65"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f8119013eccc3c3a7ae734dc7c1fc14641bde57feb18721ac335baa2bf94e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b2f8119013eccc3c3a7ae734dc7c1fc14641bde57feb18721ac335baa2bf94e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cbd78fb3559f26e9ca247003905ac6286dc0f138a3ae01fc4dc3a94311b1ca"
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
