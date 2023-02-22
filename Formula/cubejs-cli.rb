require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.64.tgz"
  sha256 "dbd9fc693b80639ceb76022345e349c5b080107c319db3e1d5b2b588316a0512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c10f755b76ef4a235ba871ef138aeeb91c6d8c8c1da194f314d4b05c548d97b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c10f755b76ef4a235ba871ef138aeeb91c6d8c8c1da194f314d4b05c548d97b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c10f755b76ef4a235ba871ef138aeeb91c6d8c8c1da194f314d4b05c548d97b"
    sha256 cellar: :any_skip_relocation, ventura:        "3933e5c6bb64c5e8ce2e05d2d993effba6e8841b526ed76c330e3e213e65d2e7"
    sha256 cellar: :any_skip_relocation, monterey:       "3933e5c6bb64c5e8ce2e05d2d993effba6e8841b526ed76c330e3e213e65d2e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3933e5c6bb64c5e8ce2e05d2d993effba6e8841b526ed76c330e3e213e65d2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c10f755b76ef4a235ba871ef138aeeb91c6d8c8c1da194f314d4b05c548d97b"
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
