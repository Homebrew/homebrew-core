class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.7.tgz"
  sha256 "6e823446a31b38f87e8bb9dd3437a0537eb49a9d7b19813b9f81c88b100c3d07"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce026b672adfcbfa83bd4bc87d92ea153dc318baeb1ea1f1a0abe98e1bd2f747"
    sha256 cellar: :any_skip_relocation, big_sur:       "39888df742337216af95a19dc405d9f7f7417380f4ee23349d6720216c1fde56"
    sha256 cellar: :any_skip_relocation, catalina:      "39888df742337216af95a19dc405d9f7f7417380f4ee23349d6720216c1fde56"
    sha256 cellar: :any_skip_relocation, mojave:        "39888df742337216af95a19dc405d9f7f7417380f4ee23349d6720216c1fde56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce026b672adfcbfa83bd4bc87d92ea153dc318baeb1ea1f1a0abe98e1bd2f747"
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
