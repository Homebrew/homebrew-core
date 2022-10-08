require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.3.tgz"
  sha256 "f4a1d3eb94326372450276075b7286608ac0b7a23a827e63b4f5c8d14c5178f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4be44a22de4b0bea551d0555a5adbdc1627581ace70bc707b99bdee33c4073"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c4be44a22de4b0bea551d0555a5adbdc1627581ace70bc707b99bdee33c4073"
    sha256 cellar: :any_skip_relocation, monterey:       "c7cc5a20035c2ee697547ffd939db701cfedc0fcb61e92dd3f9b199bf3759544"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7cc5a20035c2ee697547ffd939db701cfedc0fcb61e92dd3f9b199bf3759544"
    sha256 cellar: :any_skip_relocation, catalina:       "c7cc5a20035c2ee697547ffd939db701cfedc0fcb61e92dd3f9b199bf3759544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4be44a22de4b0bea551d0555a5adbdc1627581ace70bc707b99bdee33c4073"
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
