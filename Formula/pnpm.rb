class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.5.tgz"
  sha256 "dac12a0c586c5a7ec4410e9470dbdf9ceed5d95547719c5ece3c1c371f251743"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61c78e4dcf6816d0050f5e850a920b66f1bfb7568560264bb897e673a6bf4a1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e53acec5a6ca14a136ea73bc2ec33d300f1a06c232f543db59411fe6d0bc1327"
    sha256 cellar: :any_skip_relocation, catalina:      "e53acec5a6ca14a136ea73bc2ec33d300f1a06c232f543db59411fe6d0bc1327"
    sha256 cellar: :any_skip_relocation, mojave:        "e53acec5a6ca14a136ea73bc2ec33d300f1a06c232f543db59411fe6d0bc1327"
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
