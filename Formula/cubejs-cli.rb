require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.41.tgz"
  sha256 "e123a26c0a79da6ae75fbd80a31bd1ba6bfe47740177681c82c47a1edfc29319"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32bc21f22041157c2fc3018ee4d19fc2237e593bb51e50ef058b615f11628ba3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bbcbc2130dc67824c66845bb91ce0e4466d87bf974cf6091565c12985e4a6da"
    sha256 cellar: :any_skip_relocation, catalina:      "5bbcbc2130dc67824c66845bb91ce0e4466d87bf974cf6091565c12985e4a6da"
    sha256 cellar: :any_skip_relocation, mojave:        "5bbcbc2130dc67824c66845bb91ce0e4466d87bf974cf6091565c12985e4a6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32bc21f22041157c2fc3018ee4d19fc2237e593bb51e50ef058b615f11628ba3"
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
