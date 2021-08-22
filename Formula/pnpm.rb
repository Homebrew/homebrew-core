class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.1.tgz"
  sha256 "2547c0ec318cdfabda6604cf92ae8f90bc024c8d16cea057fe1cc762bdb85bb5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52d1cbcba6a433d4f18eef3d3efafe44ac46b41fcbbc6be1956109ce69cb305f"
    sha256 cellar: :any_skip_relocation, big_sur:       "93331513f2b08f1ef030092b63e75b0526e14aa0edb6222825ec8353dd279675"
    sha256 cellar: :any_skip_relocation, catalina:      "93331513f2b08f1ef030092b63e75b0526e14aa0edb6222825ec8353dd279675"
    sha256 cellar: :any_skip_relocation, mojave:        "93331513f2b08f1ef030092b63e75b0526e14aa0edb6222825ec8353dd279675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d1cbcba6a433d4f18eef3d3efafe44ac46b41fcbbc6be1956109ce69cb305f"
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
