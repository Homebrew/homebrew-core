class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.1.tgz"
  sha256 "c8e3ec84df0b305fb49e40b599520bf38e9bb70a0db111649555a6b580c76298"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65b1a37d705666048bb964ee9bcad28494d897ef5880cb6e15568b083162690d"
    sha256 cellar: :any_skip_relocation, big_sur:       "434314a9f2b0f37da47e658f81daca5f173bf6aad2f758dbd2cdab4b9c200b66"
    sha256 cellar: :any_skip_relocation, catalina:      "434314a9f2b0f37da47e658f81daca5f173bf6aad2f758dbd2cdab4b9c200b66"
    sha256 cellar: :any_skip_relocation, mojave:        "434314a9f2b0f37da47e658f81daca5f173bf6aad2f758dbd2cdab4b9c200b66"
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
