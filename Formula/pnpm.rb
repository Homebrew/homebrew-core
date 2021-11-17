class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.22.2.tgz"
  sha256 "e54f1a49091f47280a70def0cb94bd459f3eb90d647ebd1e6b0e3184c821a3aa"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1db2819a1d641cd852713baae1477049a7fc67f5776f896475b47453f7aeaef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1db2819a1d641cd852713baae1477049a7fc67f5776f896475b47453f7aeaef"
    sha256 cellar: :any_skip_relocation, monterey:       "05dc4da02d79c220d14296b73fa7c84be1e869f29c222254e7c6c0f8ce6a6386"
    sha256 cellar: :any_skip_relocation, big_sur:        "2814a80adfd9f0e44bca506db40e4519256e69e9e85421f8323369af0cd57c8c"
    sha256 cellar: :any_skip_relocation, catalina:       "2814a80adfd9f0e44bca506db40e4519256e69e9e85421f8323369af0cd57c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1db2819a1d641cd852713baae1477049a7fc67f5776f896475b47453f7aeaef"
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
