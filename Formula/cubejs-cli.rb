require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.40.tgz"
  sha256 "58b4b053e36dad91222dd21e664180082a8bdc83b26dde82542ad04003f25a6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4583cd9329cb6f49c91f8cab1ef7bb49e90948fa15456e7aba4f7c5b23a63eb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4583cd9329cb6f49c91f8cab1ef7bb49e90948fa15456e7aba4f7c5b23a63eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "895441f1aded2332643052dbf25fbda6ca9a2fa82fe66872a4f85913a6b961cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "895441f1aded2332643052dbf25fbda6ca9a2fa82fe66872a4f85913a6b961cf"
    sha256 cellar: :any_skip_relocation, catalina:       "895441f1aded2332643052dbf25fbda6ca9a2fa82fe66872a4f85913a6b961cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4583cd9329cb6f49c91f8cab1ef7bb49e90948fa15456e7aba4f7c5b23a63eb1"
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
