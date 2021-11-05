class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.20.3.tgz"
  sha256 "fd4db5fa81843980c9db95ba03245252f3b67d22d109a96134b6aa7424b67337"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b972d90516c1a76715b2e8fcc05d51cc8cf8883de63c7309ec380de8ebf3fe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b972d90516c1a76715b2e8fcc05d51cc8cf8883de63c7309ec380de8ebf3fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "c5762a37b9af1fc286edaf711769df9f4c48d5e93311789e783fd6cc2b87b676"
    sha256 cellar: :any_skip_relocation, big_sur:        "27eeadc814de6703c5ce3acdb7c491eb1a0a3a9ca33b458f6a64ad7cc599a2b0"
    sha256 cellar: :any_skip_relocation, catalina:       "27eeadc814de6703c5ce3acdb7c491eb1a0a3a9ca33b458f6a64ad7cc599a2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b972d90516c1a76715b2e8fcc05d51cc8cf8883de63c7309ec380de8ebf3fe3"
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
