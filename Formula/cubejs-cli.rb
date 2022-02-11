require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.28.tgz"
  sha256 "6b05a19a711730d3c689fbd5d7b45d6c88dae1e4133c3cc73b87079a428551a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9be2ed64382518b917d5cb2b2b3151bc3447be6d12d6fee9460cb3fe5448d1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9be2ed64382518b917d5cb2b2b3151bc3447be6d12d6fee9460cb3fe5448d1b"
    sha256 cellar: :any_skip_relocation, monterey:       "945e02f7b12b40bc4fd96e54a9cbc43427a34393935cfe9ff16ddecb24eff5bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "945e02f7b12b40bc4fd96e54a9cbc43427a34393935cfe9ff16ddecb24eff5bd"
    sha256 cellar: :any_skip_relocation, catalina:       "945e02f7b12b40bc4fd96e54a9cbc43427a34393935cfe9ff16ddecb24eff5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9be2ed64382518b917d5cb2b2b3151bc3447be6d12d6fee9460cb3fe5448d1b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
