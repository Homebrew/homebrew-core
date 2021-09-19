require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.37.tgz"
  sha256 "bc6a33694589a4bf00561bfbca0b7c52e074fe74a5aeb118af18c25f54d4188c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3b1b4bdf94e4e3cfe39b6a14cf612ca0452b017b943fb3b6b1518a7caf1fa90"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a8e8487956e3c548679790220fe0577d7ee7b48f97f0999dee1d3f757716cb8"
    sha256 cellar: :any_skip_relocation, catalina:      "8a8e8487956e3c548679790220fe0577d7ee7b48f97f0999dee1d3f757716cb8"
    sha256 cellar: :any_skip_relocation, mojave:        "8a8e8487956e3c548679790220fe0577d7ee7b48f97f0999dee1d3f757716cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b1b4bdf94e4e3cfe39b6a14cf612ca0452b017b943fb3b6b1518a7caf1fa90"
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
