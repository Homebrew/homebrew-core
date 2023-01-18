require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.46.tgz"
  sha256 "3f107de4f20dfd8cae3b8f529494e8b0070151ab92c38d8605ea7391f016c469"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "744fd375cd4c378c21e5920af4f353358493108c589ea66b08f586cba4d2eaac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744fd375cd4c378c21e5920af4f353358493108c589ea66b08f586cba4d2eaac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "744fd375cd4c378c21e5920af4f353358493108c589ea66b08f586cba4d2eaac"
    sha256 cellar: :any_skip_relocation, ventura:        "06b0b952ab47a9c57cef307eb3249bdb623f911dd23809727278948b9b4ef04d"
    sha256 cellar: :any_skip_relocation, monterey:       "06b0b952ab47a9c57cef307eb3249bdb623f911dd23809727278948b9b4ef04d"
    sha256 cellar: :any_skip_relocation, big_sur:        "06b0b952ab47a9c57cef307eb3249bdb623f911dd23809727278948b9b4ef04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744fd375cd4c378c21e5920af4f353358493108c589ea66b08f586cba4d2eaac"
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
