require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.68.tgz"
  sha256 "ab808e53095c6826de72eb08f4fe6717b7659eeda925da320a2338433090dd09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b42351986f489814053e2cd0c62fd1ce9cce0e3d30d2ac2382a0fc259472dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b42351986f489814053e2cd0c62fd1ce9cce0e3d30d2ac2382a0fc259472dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b42351986f489814053e2cd0c62fd1ce9cce0e3d30d2ac2382a0fc259472dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "fd748a5b9e247be4215d460a2b1e659ad2c9a13dd561be8f0ddf5b7c825666bc"
    sha256 cellar: :any_skip_relocation, monterey:       "fd748a5b9e247be4215d460a2b1e659ad2c9a13dd561be8f0ddf5b7c825666bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd748a5b9e247be4215d460a2b1e659ad2c9a13dd561be8f0ddf5b7c825666bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b42351986f489814053e2cd0c62fd1ce9cce0e3d30d2ac2382a0fc259472dbf"
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
