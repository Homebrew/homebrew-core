class Corepack < Formula
  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https://github.com/nodejs/corepack"
  url "https://registry.npmjs.org/corepack/-/corepack-0.29.3.tgz"
  sha256 "63b88391da952a8c977e1e85db734bfa975805cf22c1c5dc5dc9e54eb9eed97e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/corepack/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02602f24c46d8852d823a87c5e7877f8c8cb1de3cf90a9dcad3716f6d8d36988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02602f24c46d8852d823a87c5e7877f8c8cb1de3cf90a9dcad3716f6d8d36988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02602f24c46d8852d823a87c5e7877f8c8cb1de3cf90a9dcad3716f6d8d36988"
    sha256 cellar: :any_skip_relocation, sonoma:         "02602f24c46d8852d823a87c5e7877f8c8cb1de3cf90a9dcad3716f6d8d36988"
    sha256 cellar: :any_skip_relocation, ventura:        "02602f24c46d8852d823a87c5e7877f8c8cb1de3cf90a9dcad3716f6d8d36988"
    sha256 cellar: :any_skip_relocation, monterey:       "02602f24c46d8852d823a87c5e7877f8c8cb1de3cf90a9dcad3716f6d8d36988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b27d9b337822a292d6ceb524c40d09ee459455265aec4f8c0221cf5a937db6"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"
  conflicts_with "pnpm", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"corepack"

    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    system bin/"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?

    (testpath/"package.json").delete
    system bin/"pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
