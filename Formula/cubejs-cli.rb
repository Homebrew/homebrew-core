require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.49.tgz"
  sha256 "67c8fff930e1989c23c9bc0fb18eeed411cfb2e058c754f025a5fed10de0c43f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ed0019831d9acb42fa5508cf725a38400582282a54da6cac2d9bf471e83d5dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd56a0db2a5c4887482d1d2e8a26104afef1b68d8a90c6e3d5ef24b662d83b0b"
    sha256 cellar: :any_skip_relocation, catalina:      "cd56a0db2a5c4887482d1d2e8a26104afef1b68d8a90c6e3d5ef24b662d83b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ed0019831d9acb42fa5508cf725a38400582282a54da6cac2d9bf471e83d5dd"
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
