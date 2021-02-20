class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.17.2.tgz"
  sha256 "83be73c9726f172be3f59fbf23de9ba5683b76b6146096d84e8327005985886d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89d276527d0a541128c5d8ba7fce3ef7d5dda023a31adc0755419a2d17066cf4"
    sha256 cellar: :any_skip_relocation, big_sur:       "13259d0550d773fe7515beb4ca3e24ca55beff2bb852a4555cc5b0cbca14c7e3"
    sha256 cellar: :any_skip_relocation, catalina:      "93051f7dbf74b352ed82dc88c603a735ca078ea6dc4ee22658a38b8cf8d4f34c"
    sha256 cellar: :any_skip_relocation, mojave:        "7252c6397febe4943f6997cdb98dc3a155bc405e5e049e3e32ec75307072093c"
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
