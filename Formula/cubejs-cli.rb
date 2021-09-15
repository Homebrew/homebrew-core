require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.36.tgz"
  sha256 "d1ef5bfa9dcfb5886621b093964e3590a110e8388e4b4779e8d1d784547a978c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56dc29968b99af235516b12a4d620618fad656fb7376ff0d0cc7bf3cee3aeabe"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6fa0a74d58925fc3f9f26cfc71e16939f443dd4e9b77a7fa2c742cbcdb3f0b1"
    sha256 cellar: :any_skip_relocation, catalina:      "a6fa0a74d58925fc3f9f26cfc71e16939f443dd4e9b77a7fa2c742cbcdb3f0b1"
    sha256 cellar: :any_skip_relocation, mojave:        "a6fa0a74d58925fc3f9f26cfc71e16939f443dd4e9b77a7fa2c742cbcdb3f0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56dc29968b99af235516b12a4d620618fad656fb7376ff0d0cc7bf3cee3aeabe"
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
