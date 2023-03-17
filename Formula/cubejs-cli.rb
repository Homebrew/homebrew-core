require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.8.tgz"
  sha256 "096d321e94a0604be573ae335e1b1c0a7c736d07a69d2abf9e9484eb38a1db9d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88a3e2e07792479db3252d67d8dc905d2dc35a284bb899ee7450881d3fba572e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a3e2e07792479db3252d67d8dc905d2dc35a284bb899ee7450881d3fba572e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88a3e2e07792479db3252d67d8dc905d2dc35a284bb899ee7450881d3fba572e"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c8cf2f729358613bdad83bcd51da1fad7443cb9b0292e5157a883ab5c64486"
    sha256 cellar: :any_skip_relocation, monterey:       "a9c8cf2f729358613bdad83bcd51da1fad7443cb9b0292e5157a883ab5c64486"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9c8cf2f729358613bdad83bcd51da1fad7443cb9b0292e5157a883ab5c64486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a3e2e07792479db3252d67d8dc905d2dc35a284bb899ee7450881d3fba572e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
