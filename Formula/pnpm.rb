class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.18.0.tgz"
  sha256 "5472b2ed77e507098861486bfe1d1b812e19dd22d89fca172c74d622ddfffda3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a79bc5bb58cca9596a1326976527ad4be95af37fd899892fc2b4239b0c782fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c77e3462bce306543c5f27023e715524d2418b74762c4820539c1444b9182df"
    sha256 cellar: :any_skip_relocation, catalina:      "7c77e3462bce306543c5f27023e715524d2418b74762c4820539c1444b9182df"
    sha256 cellar: :any_skip_relocation, mojave:        "7c77e3462bce306543c5f27023e715524d2418b74762c4820539c1444b9182df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a79bc5bb58cca9596a1326976527ad4be95af37fd899892fc2b4239b0c782fc"
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
