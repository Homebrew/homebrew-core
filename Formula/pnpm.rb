class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.8.0.tgz"
  sha256 "d909b8b81fa4d348330d7fe9d710394edfebc084a38a29c90a4b4d61bef5d0a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "adbc1eacce446b1dcb53312d3db0e8ab876a03cab11b47f6a577a7245220e7a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "86f64bc2fab2ab987510b2064b295ccfd2d150c7da5de89da16b53af5eecc1a2"
    sha256 cellar: :any_skip_relocation, catalina:      "86f64bc2fab2ab987510b2064b295ccfd2d150c7da5de89da16b53af5eecc1a2"
    sha256 cellar: :any_skip_relocation, mojave:        "86f64bc2fab2ab987510b2064b295ccfd2d150c7da5de89da16b53af5eecc1a2"
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
