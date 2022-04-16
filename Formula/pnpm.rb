class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.8.tgz"
  sha256 "174f17e00423c1ba1a4e382c89021feaa254cc4083e4bb433ed3ec0a0c21ff5a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb84077f7091cdb4998f7d9cbcdef0663f5005e8c99b1e32e55ca0a9241845ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb84077f7091cdb4998f7d9cbcdef0663f5005e8c99b1e32e55ca0a9241845ad"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d85676f31743eaec772086bb95c74ea21d9f671d381b2f0fcd421223bc43b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "662eb836285ff0d80be83e5449713c76253e51858ed9f95b83ec9d24c12dddff"
    sha256 cellar: :any_skip_relocation, catalina:       "662eb836285ff0d80be83e5449713c76253e51858ed9f95b83ec9d24c12dddff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb84077f7091cdb4998f7d9cbcdef0663f5005e8c99b1e32e55ca0a9241845ad"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
