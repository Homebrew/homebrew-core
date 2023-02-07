require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.59.tgz"
  sha256 "2957602f2630320d360ced7e632f630464bc802d44ec70a3f74ce85b47449e9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7242fbe8b468e86d10c0257395af0f4abf91fffb154471890ed3807e68cd96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7242fbe8b468e86d10c0257395af0f4abf91fffb154471890ed3807e68cd96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e7242fbe8b468e86d10c0257395af0f4abf91fffb154471890ed3807e68cd96"
    sha256 cellar: :any_skip_relocation, ventura:        "dccd65545e44cbc2f5fbe67a64fad8d273f2b92f22488d9873c171f443474977"
    sha256 cellar: :any_skip_relocation, monterey:       "dccd65545e44cbc2f5fbe67a64fad8d273f2b92f22488d9873c171f443474977"
    sha256 cellar: :any_skip_relocation, big_sur:        "dccd65545e44cbc2f5fbe67a64fad8d273f2b92f22488d9873c171f443474977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7242fbe8b468e86d10c0257395af0f4abf91fffb154471890ed3807e68cd96"
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
