class Corepack < Formula
  require "language/node"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https://github.com/nodejs/corepack"
  url "https://registry.npmjs.org/corepack/-/corepack-0.28.2.tgz"
  sha256 "daff10b695570c121d1e9d13a140db517894b11f806160107e56abf322f04c56"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/corepack/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e46a109c0b29a698d873f7e21f99f8ae76ebef3a566b529440129ed8431ffd40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e46a109c0b29a698d873f7e21f99f8ae76ebef3a566b529440129ed8431ffd40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46a109c0b29a698d873f7e21f99f8ae76ebef3a566b529440129ed8431ffd40"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46a109c0b29a698d873f7e21f99f8ae76ebef3a566b529440129ed8431ffd40"
    sha256 cellar: :any_skip_relocation, ventura:        "e46a109c0b29a698d873f7e21f99f8ae76ebef3a566b529440129ed8431ffd40"
    sha256 cellar: :any_skip_relocation, monterey:       "e46a109c0b29a698d873f7e21f99f8ae76ebef3a566b529440129ed8431ffd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5e3bf758540a82d4ce4b95b6bd99b6c18c1ab99e436878f05f9ae3ead3bcaf"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "pnpm", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"corepack"

    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    system bin/"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?

    (testpath/"package.json").delete
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
