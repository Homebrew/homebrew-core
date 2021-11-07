require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.53.tgz"
  sha256 "6024718834d7282212dec4b774d874fdd0ca59ade46b47014caa0febd1a13cef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9054889b5e85350ba26a25dbe5ac565684ae147164896a62ee8332723dc3195e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9054889b5e85350ba26a25dbe5ac565684ae147164896a62ee8332723dc3195e"
    sha256 cellar: :any_skip_relocation, monterey:       "248efa5cdb6c6a14405a00973efc759e8d432e18b52bdc3244db54eb5f9fc9c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "248efa5cdb6c6a14405a00973efc759e8d432e18b52bdc3244db54eb5f9fc9c5"
    sha256 cellar: :any_skip_relocation, catalina:       "248efa5cdb6c6a14405a00973efc759e8d432e18b52bdc3244db54eb5f9fc9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9054889b5e85350ba26a25dbe5ac565684ae147164896a62ee8332723dc3195e"
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
