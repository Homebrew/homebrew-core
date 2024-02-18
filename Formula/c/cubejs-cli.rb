require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.55.tgz"
  sha256 "305449108d73109474c4158f242af43bb7d7991073fcdb199cd769d8b4449aad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "32e677d62caf085cf99abc2b7eb6fa6e3d478fdd1ee5b09740bbbeca79e5fe9a"
    sha256 cellar: :any, arm64_ventura:  "32e677d62caf085cf99abc2b7eb6fa6e3d478fdd1ee5b09740bbbeca79e5fe9a"
    sha256 cellar: :any, arm64_monterey: "32e677d62caf085cf99abc2b7eb6fa6e3d478fdd1ee5b09740bbbeca79e5fe9a"
    sha256 cellar: :any, sonoma:         "f898c42f059089614c05301549688c7cc2d5b227e663acfc0cf8408cfa8adab9"
    sha256 cellar: :any, ventura:        "f898c42f059089614c05301549688c7cc2d5b227e663acfc0cf8408cfa8adab9"
    sha256 cellar: :any, monterey:       "f898c42f059089614c05301549688c7cc2d5b227e663acfc0cf8408cfa8adab9"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
