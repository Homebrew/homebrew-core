class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.17.2.tgz"
  sha256 "83be73c9726f172be3f59fbf23de9ba5683b76b6146096d84e8327005985886d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11f9604730bc478bd4095ea664c38c84781b3dfb5739ce31a0af9ef430db6481"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6e273c78cc21a7deb9c669ad89eda36fdfda1aa5b0dc77582c1e4462b422a6a"
    sha256 cellar: :any_skip_relocation, catalina:      "addb2ded0629f354f25404b87effc71d2b2b66cc5b9a7f90688f538f357cb59d"
    sha256 cellar: :any_skip_relocation, mojave:        "d7ae1f93514180b9e3500efd728fa526f7fd4ff85a9d7145684d8a0653221609"
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
