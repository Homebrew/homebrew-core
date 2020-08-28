require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.20.0.tgz"
  sha256 "2413760b8ad7a4b7d545b79c677abfed5af09cc62162d711ea10f784a83ec050"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "19dfc97e6e8540fd4f76c610eccf054b3608b2634d7af66d718b52bab1440dc8" => :catalina
    sha256 "02fbb5d9e40a88117a12497948f1becea8cfe62231b9c97cafaf360b7c152bcd" => :mojave
    sha256 "d6829b820fc90d395a6bf49ee418ce3318b7f711d3d48a844bceeea6f1ee0902" => :high_sierra
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
