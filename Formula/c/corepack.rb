class Corepack < Formula
  require "language/node"

  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https://github.com/nodejs/corepack"
  url "https://registry.npmjs.org/corepack/-/corepack-0.28.1.tgz"
  sha256 "39498c77b1fa6f81d55e0783ddbef1cef217cbed2874c35d43a01a6e35be374a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/corepack/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57ffbc8205c1e182e0afae40cbb27d306c2b7184426e19a3f850589ad59769fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "287201bda35d3816d00789714b70756a0fac68e7de9467f58f96f02ccb6a1ea3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54f9bde946d68d0ca603b4e64e5b934124b660397fc2e06cc1809cc264076e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b667326642ea72e92017a4f3bc6811b8f8eb0f26aa4a5666c457a47d37bc5e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "db6e39847795ca3b3974f8885e2d22e9898207984583cda43d080048a6073866"
    sha256 cellar: :any_skip_relocation, monterey:       "f306864f50b9c5499c009587380654a5dc77a5434a01bf1b2a700507ec5c65a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396dde377fb45cfaa6423d1f3dfee96f74d7d4d8e6bd2d4d7abb48da517c37d8"
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
