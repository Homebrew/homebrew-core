require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.14.tgz"
  sha256 "11c4c299d5cf0f804c1890c137e1a7bb2d7670b7972cced943adfa68d9485769"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c1968c72d4b5b52fbc1dc50dd9464d3f81b57d42d5a08c7d385a9a9c2e5be8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c1968c72d4b5b52fbc1dc50dd9464d3f81b57d42d5a08c7d385a9a9c2e5be8c"
    sha256 cellar: :any_skip_relocation, monterey:       "590584d9be63d32b95eaf193153a64e983711ff38d9c746907d52134c655dbec"
    sha256 cellar: :any_skip_relocation, big_sur:        "590584d9be63d32b95eaf193153a64e983711ff38d9c746907d52134c655dbec"
    sha256 cellar: :any_skip_relocation, catalina:       "590584d9be63d32b95eaf193153a64e983711ff38d9c746907d52134c655dbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c1968c72d4b5b52fbc1dc50dd9464d3f81b57d42d5a08c7d385a9a9c2e5be8c"
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
