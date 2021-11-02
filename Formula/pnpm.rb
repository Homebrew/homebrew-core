class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.20.1.tgz"
  sha256 "185e6199d9b7ba30d2a4129776eecbb82d78046616ea94b5a839044451b1a271"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ba5ed7c23ef0a16a2de099215c0d16d1796e7204e1ca5ccf75485ba93874a37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ba5ed7c23ef0a16a2de099215c0d16d1796e7204e1ca5ccf75485ba93874a37"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6423aa8478f7d6d216d5e75f7916d599a03638879c2c48783e55ee31248821"
    sha256 cellar: :any_skip_relocation, big_sur:        "1116ba4b1d524325b5baf9d8c7a6347356ff52071ce69d4997c947e82d606fbc"
    sha256 cellar: :any_skip_relocation, catalina:       "1116ba4b1d524325b5baf9d8c7a6347356ff52071ce69d4997c947e82d606fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba5ed7c23ef0a16a2de099215c0d16d1796e7204e1ca5ccf75485ba93874a37"
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
