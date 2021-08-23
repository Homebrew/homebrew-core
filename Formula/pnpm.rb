class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.14.2.tgz"
  sha256 "b3f22608d5a33beadc6c86ebc365803f5d315cce05edb6cbfa6c6615f4654eb1"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4a2f4e96ce3bf02372863ee36a2ff736a6c50de1c7693248c88243e927cee0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "cedd688cd67dec5379c6b6b6f54581b757bfd691055b94da0f175eb45c7acb9c"
    sha256 cellar: :any_skip_relocation, catalina:      "cedd688cd67dec5379c6b6b6f54581b757bfd691055b94da0f175eb45c7acb9c"
    sha256 cellar: :any_skip_relocation, mojave:        "cedd688cd67dec5379c6b6b6f54581b757bfd691055b94da0f175eb45c7acb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a2f4e96ce3bf02372863ee36a2ff736a6c50de1c7693248c88243e927cee0e"
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
