class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.3.tgz"
  sha256 "05efd83bb0b9f3ee21f52c09d463632f34faa0dc8675617fa1b95cb84f7202b6"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "097cae5710f8217c0943da15577a641564827cb18e2005ad5e3576e0b683202d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d67cdcd3811dfb38498a18e3bee97181e0320fd6a8e189f660db6d4b3b5dc945"
    sha256 cellar: :any_skip_relocation, catalina:      "d67cdcd3811dfb38498a18e3bee97181e0320fd6a8e189f660db6d4b3b5dc945"
    sha256 cellar: :any_skip_relocation, mojave:        "d67cdcd3811dfb38498a18e3bee97181e0320fd6a8e189f660db6d4b3b5dc945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097cae5710f8217c0943da15577a641564827cb18e2005ad5e3576e0b683202d"
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
