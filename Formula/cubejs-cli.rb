require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.12.tgz"
  sha256 "a0b76bd6120c628b5d3bdea0dbd385220db1ad6bbdf3ae6de4ee174cb616843a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "613a96599f33929cd704dd36bd5a0dc36346b2a5a7ae8c504266fe63b1a3c422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "613a96599f33929cd704dd36bd5a0dc36346b2a5a7ae8c504266fe63b1a3c422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "613a96599f33929cd704dd36bd5a0dc36346b2a5a7ae8c504266fe63b1a3c422"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b001419f4e82f46ccd222fa384fea0b259a1a985d82d9ee005d18dbeba26bd"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b001419f4e82f46ccd222fa384fea0b259a1a985d82d9ee005d18dbeba26bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9b001419f4e82f46ccd222fa384fea0b259a1a985d82d9ee005d18dbeba26bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613a96599f33929cd704dd36bd5a0dc36346b2a5a7ae8c504266fe63b1a3c422"
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
