class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.7.tgz"
  sha256 "63e143444ad8d93774b6b420f47d27171a64b06cf6fdead68de60ca0b440e156"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43865d6e234a0cb497345c3811a3c5bd4154cde26703636b880578bc80dabd72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43865d6e234a0cb497345c3811a3c5bd4154cde26703636b880578bc80dabd72"
    sha256 cellar: :any_skip_relocation, monterey:       "2f2eb641356624c5b9075da18c9304b547efaa19946be9b03158c7bf4f5954b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b45d5000b80eb717b661f88e1fd6563780a96ad7eec93a71880e4f07b3a1587c"
    sha256 cellar: :any_skip_relocation, catalina:       "b45d5000b80eb717b661f88e1fd6563780a96ad7eec93a71880e4f07b3a1587c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43865d6e234a0cb497345c3811a3c5bd4154cde26703636b880578bc80dabd72"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
