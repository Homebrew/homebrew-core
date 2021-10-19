require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.44.tgz"
  sha256 "3aba592eb829d24090a4c253eba51b670f186d0165b61988b2ddc50e2c2d0b39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c2537a6809b20c30040b0a54a59ff176e7ffdcec1b659e8bdbbc54f80c3b5b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "db41a6f0c42fe611784082d5ba9ed08b1796564a260b4d5ef9487a23f4bc014d"
    sha256 cellar: :any_skip_relocation, catalina:      "db41a6f0c42fe611784082d5ba9ed08b1796564a260b4d5ef9487a23f4bc014d"
    sha256 cellar: :any_skip_relocation, mojave:        "db41a6f0c42fe611784082d5ba9ed08b1796564a260b4d5ef9487a23f4bc014d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2537a6809b20c30040b0a54a59ff176e7ffdcec1b659e8bdbbc54f80c3b5b3"
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
