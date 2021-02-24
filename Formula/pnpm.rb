class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.0.tgz"
  sha256 "0aa2a4d13eb683a9b7576f91c7faf56c8c43d59d1eb397259b0678c85f49f084"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99b53f05b6f53de25b7c1ed1bb724412cdb0ef1d302c053b4cb035e4034ba897"
    sha256 cellar: :any_skip_relocation, big_sur:       "660148606a5226edee86d400e2b24f618d212bf1ea89ee330f3ba56a03784f0f"
    sha256 cellar: :any_skip_relocation, catalina:      "f5bfeb7b2027cf17c888c51ab064a43a7d9eb6fee4264d576a10bcabb49e5a15"
    sha256 cellar: :any_skip_relocation, mojave:        "afc4db2c8a177d3b748b99afed6edf6c7f16ca91af1ba88054ed753f1bf63cd4"
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
