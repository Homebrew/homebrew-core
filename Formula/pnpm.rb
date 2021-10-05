class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.16.1.tgz"
  sha256 "2a40a3d8a56eaa411819fb8aa8cdd4d9fe729f74571929311247922387925f5a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8b2d275f27cbdcc1d1211feb5a8e0b9d239145894514c1cf56363173546547d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9c977021b7e3c8717c53154d23095d2ef3d171a0a6e9b77c096450fda209ce7"
    sha256 cellar: :any_skip_relocation, catalina:      "d9c977021b7e3c8717c53154d23095d2ef3d171a0a6e9b77c096450fda209ce7"
    sha256 cellar: :any_skip_relocation, mojave:        "d9c977021b7e3c8717c53154d23095d2ef3d171a0a6e9b77c096450fda209ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b2d275f27cbdcc1d1211feb5a8e0b9d239145894514c1cf56363173546547d"
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
