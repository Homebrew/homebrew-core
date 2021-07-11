class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.10.0.tgz"
  sha256 "a2b19cebe4bd74936fa17e6f1275effd50e13447ea32ea9c7964798d370a8e04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d335fb92fc9a9e3afd64e9432be3e5f46d4183e1a057b02a5ffeb44bd6bc0d4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "1818e3edbec01458e8ad278f45d7cb662a5ab9051c690b17f565ceef74e74e6b"
    sha256 cellar: :any_skip_relocation, catalina:      "1818e3edbec01458e8ad278f45d7cb662a5ab9051c690b17f565ceef74e74e6b"
    sha256 cellar: :any_skip_relocation, mojave:        "1818e3edbec01458e8ad278f45d7cb662a5ab9051c690b17f565ceef74e74e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67f9fc49ed8e97f04101f1125df6750ca25400c28c7f890f0b7facf64e759272"
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
