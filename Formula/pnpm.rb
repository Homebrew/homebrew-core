class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.32.0.tgz"
  sha256 "f2d630e3b1a55d32813b47d5a0746bf36ca94aa56cb87d10977d8e3cae5adee4"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6d57efe102e48acc2e331ef40ccde87b16b2561181199d91cf03963f75d0d21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6d57efe102e48acc2e331ef40ccde87b16b2561181199d91cf03963f75d0d21"
    sha256 cellar: :any_skip_relocation, monterey:       "12420d1cb801b0eaf17add4096196f9f3db86c425597f9f13e3c391a7328ded5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6f6dbc38d2aca2c9fdf64e15aef12906d43a8614358635eba0f1bf30242654d"
    sha256 cellar: :any_skip_relocation, catalina:       "b6f6dbc38d2aca2c9fdf64e15aef12906d43a8614358635eba0f1bf30242654d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d57efe102e48acc2e331ef40ccde87b16b2561181199d91cf03963f75d0d21"
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
