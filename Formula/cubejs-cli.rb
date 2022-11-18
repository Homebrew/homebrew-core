require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.15.tgz"
  sha256 "cc6ec742081abb47d35d19a7fe8282258992197946a7dee4e03ee900fae83ec9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec427972f51c1be6d9e2b9bfe52f61d21d935caae95dabf9b0ad4748d67feddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec427972f51c1be6d9e2b9bfe52f61d21d935caae95dabf9b0ad4748d67feddb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec427972f51c1be6d9e2b9bfe52f61d21d935caae95dabf9b0ad4748d67feddb"
    sha256 cellar: :any_skip_relocation, monterey:       "eacab3ae6b076f59d42ab85bb1f52a75f883dc96791cba4c17a730274f71c77a"
    sha256 cellar: :any_skip_relocation, big_sur:        "eacab3ae6b076f59d42ab85bb1f52a75f883dc96791cba4c17a730274f71c77a"
    sha256 cellar: :any_skip_relocation, catalina:       "eacab3ae6b076f59d42ab85bb1f52a75f883dc96791cba4c17a730274f71c77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec427972f51c1be6d9e2b9bfe52f61d21d935caae95dabf9b0ad4748d67feddb"
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
