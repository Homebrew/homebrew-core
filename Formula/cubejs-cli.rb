require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.35.tgz"
  sha256 "d458687672786403a9f72c3771684b70adb9b9ec65cd05e2ae8b66cab6cf5bfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eeb8890e5155616e1b796b102a6669479fe4103fd861747b5881a8a87cf9f04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eeb8890e5155616e1b796b102a6669479fe4103fd861747b5881a8a87cf9f04"
    sha256 cellar: :any_skip_relocation, monterey:       "903989d6cfa756d7f220cbd8f548b917ac1ad9a965cd12b09e4d37855c52a37c"
    sha256 cellar: :any_skip_relocation, big_sur:        "903989d6cfa756d7f220cbd8f548b917ac1ad9a965cd12b09e4d37855c52a37c"
    sha256 cellar: :any_skip_relocation, catalina:       "903989d6cfa756d7f220cbd8f548b917ac1ad9a965cd12b09e4d37855c52a37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eeb8890e5155616e1b796b102a6669479fe4103fd861747b5881a8a87cf9f04"
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
