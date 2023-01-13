require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.39.tgz"
  sha256 "30f3c5c550d2b307dacc35e478b6481fbaec3be3e2429d29e2ce8f9d9cd02581"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de9ac7f1ae84bb17378a150d1eb4cd1f0741361b16b6cff90df7ea53b33b297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8de9ac7f1ae84bb17378a150d1eb4cd1f0741361b16b6cff90df7ea53b33b297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8de9ac7f1ae84bb17378a150d1eb4cd1f0741361b16b6cff90df7ea53b33b297"
    sha256 cellar: :any_skip_relocation, ventura:        "4685c525777fcf9bfb55d4ac391f9d657d7caf690d52b175ed3971d7a44e6ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "4685c525777fcf9bfb55d4ac391f9d657d7caf690d52b175ed3971d7a44e6ed1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4685c525777fcf9bfb55d4ac391f9d657d7caf690d52b175ed3971d7a44e6ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de9ac7f1ae84bb17378a150d1eb4cd1f0741361b16b6cff90df7ea53b33b297"
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
