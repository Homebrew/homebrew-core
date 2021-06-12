require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.32.tgz"
  sha256 "c92165f91b76cc1714d8ec537fee826dca8f52a1f4996f88fe4b6ca969006403"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fb755a42fab279cec5b1654388d4fb8ffdf26fc3e12c47d8e5d07e231075b55"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d222991c4fc18c2aa28d6f7097a4a16f44f67e224e5719940ff498dd80bc0fd"
    sha256 cellar: :any_skip_relocation, catalina:      "8d222991c4fc18c2aa28d6f7097a4a16f44f67e224e5719940ff498dd80bc0fd"
    sha256 cellar: :any_skip_relocation, mojave:        "8d222991c4fc18c2aa28d6f7097a4a16f44f67e224e5719940ff498dd80bc0fd"
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
