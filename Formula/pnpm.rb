class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.30.0.tgz"
  sha256 "abe30b2fd43471b4524ea206d6b4dc303ea0588c7f55ad6059d75eb2a795a9c1"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc94b67cb9b8f8205d8ba1030c39eda09e3cc969f1afe4a674de4f96a95e312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bc94b67cb9b8f8205d8ba1030c39eda09e3cc969f1afe4a674de4f96a95e312"
    sha256 cellar: :any_skip_relocation, monterey:       "84b001258f42182f148a6845dcaa1bd22cb03946eb40047b8f35dfa1e8ccedb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d52dddcb141da93a22002bf0f0235c8e43fdffebe1bd0194ce21d5d6cd8b3722"
    sha256 cellar: :any_skip_relocation, catalina:       "d52dddcb141da93a22002bf0f0235c8e43fdffebe1bd0194ce21d5d6cd8b3722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bc94b67cb9b8f8205d8ba1030c39eda09e3cc969f1afe4a674de4f96a95e312"
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
