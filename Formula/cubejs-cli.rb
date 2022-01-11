require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.20.tgz"
  sha256 "145ee36757faba840374c630f41541f7fecd925739bbfc11cd51483a03e91ee1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3287d79fbb3beacb2f58c2f48cdb01e26b5a435197a109570a2928afc32787b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3287d79fbb3beacb2f58c2f48cdb01e26b5a435197a109570a2928afc32787b0"
    sha256 cellar: :any_skip_relocation, monterey:       "b0dbf476d6c163ef5d90d5b3c9df300cae7fcfea8a96699eb068252ec9f3517d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ed634acbecb54536ea8645fd4ba85e13d9c369dcd1f9afc884bd91421feeb99"
    sha256 cellar: :any_skip_relocation, catalina:       "5ed634acbecb54536ea8645fd4ba85e13d9c369dcd1f9afc884bd91421feeb99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3287d79fbb3beacb2f58c2f48cdb01e26b5a435197a109570a2928afc32787b0"
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
