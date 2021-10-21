require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.46.tgz"
  sha256 "0f09535fc500b417c844481b5c96849d0f1de43869ebfc0738e38042ccaa49d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "666ca9b5c9aa8599705d7aa6f3c022d9dbc3007c0c51730b03b210633919a30f"
    sha256 cellar: :any_skip_relocation, big_sur:       "eac5a3efadd12b961fd03cc4c7546a2254cac80286a4f1cc9695cdbfaa8027e8"
    sha256 cellar: :any_skip_relocation, catalina:      "eac5a3efadd12b961fd03cc4c7546a2254cac80286a4f1cc9695cdbfaa8027e8"
    sha256 cellar: :any_skip_relocation, mojave:        "eac5a3efadd12b961fd03cc4c7546a2254cac80286a4f1cc9695cdbfaa8027e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666ca9b5c9aa8599705d7aa6f3c022d9dbc3007c0c51730b03b210633919a30f"
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
