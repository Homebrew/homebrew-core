class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.12.1.tgz"
  sha256 "4037e78e0ec637e90c86ed5765cd4409c3deb0a6ca2a9864b202bb957e328ed9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efcac832dc165a64bbb93b7018876cf7dc70d669ae3b1f2a68c46ea0bcddc572"
    sha256 cellar: :any_skip_relocation, big_sur:       "9eb2f3321905d4d8cf6e42aefdb051b128d91d8114e49e122a23c05af5c767cc"
    sha256 cellar: :any_skip_relocation, catalina:      "9eb2f3321905d4d8cf6e42aefdb051b128d91d8114e49e122a23c05af5c767cc"
    sha256 cellar: :any_skip_relocation, mojave:        "9eb2f3321905d4d8cf6e42aefdb051b128d91d8114e49e122a23c05af5c767cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efcac832dc165a64bbb93b7018876cf7dc70d669ae3b1f2a68c46ea0bcddc572"
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
