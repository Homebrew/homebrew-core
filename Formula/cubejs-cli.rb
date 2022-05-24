require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.6.tgz"
  sha256 "9fc1ac60ded93ccbe4912e0bf10f20c630839966a4b5174ca06d1b8fbbe92249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a4897ee143255daa63cca2d4ed008e74a56e2f2a4b80c7d29e76834091f4d9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a4897ee143255daa63cca2d4ed008e74a56e2f2a4b80c7d29e76834091f4d9c"
    sha256 cellar: :any_skip_relocation, monterey:       "62ba4bb62245986ff4c1776767c2ffa341355eb24fa1b1f5927a9016c5fe1e9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "62ba4bb62245986ff4c1776767c2ffa341355eb24fa1b1f5927a9016c5fe1e9e"
    sha256 cellar: :any_skip_relocation, catalina:       "62ba4bb62245986ff4c1776767c2ffa341355eb24fa1b1f5927a9016c5fe1e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4897ee143255daa63cca2d4ed008e74a56e2f2a4b80c7d29e76834091f4d9c"
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
