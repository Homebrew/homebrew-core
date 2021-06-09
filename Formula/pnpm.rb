class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.4.tgz"
  sha256 "89d4bffe35704d179e9325ec60accbe4ab0dbee08c2f9c54b6caa1f62c32f4d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c16575fd0a13d57a34596ec7a140fcef5dde487af258377038f2a0a4028324f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "9819d3d4f28845018735bd6df8946f008e7659fca7ba25a2dd17d89343be9d94"
    sha256 cellar: :any_skip_relocation, catalina:      "9819d3d4f28845018735bd6df8946f008e7659fca7ba25a2dd17d89343be9d94"
    sha256 cellar: :any_skip_relocation, mojave:        "9819d3d4f28845018735bd6df8946f008e7659fca7ba25a2dd17d89343be9d94"
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
