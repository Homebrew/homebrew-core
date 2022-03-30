require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.37.tgz"
  sha256 "98fff58a0640a5602ff189f8f6d92eb715bc302288155f323efce3457d4d61c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac1eb2df9d7dcb6f6bfd127f5fbde64eba8e4d595f36b5523dbc058b146ae643"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac1eb2df9d7dcb6f6bfd127f5fbde64eba8e4d595f36b5523dbc058b146ae643"
    sha256 cellar: :any_skip_relocation, monterey:       "8205e7fb4c076563b3b9cac76a66a73f945eb90c3c343bd4985abb16cb190861"
    sha256 cellar: :any_skip_relocation, big_sur:        "8205e7fb4c076563b3b9cac76a66a73f945eb90c3c343bd4985abb16cb190861"
    sha256 cellar: :any_skip_relocation, catalina:       "8205e7fb4c076563b3b9cac76a66a73f945eb90c3c343bd4985abb16cb190861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1eb2df9d7dcb6f6bfd127f5fbde64eba8e4d595f36b5523dbc058b146ae643"
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
