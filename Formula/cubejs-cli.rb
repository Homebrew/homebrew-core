require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.46.tgz"
  sha256 "e837158934f872c15b8071ebd6c3b5ad3e8df8db1e955aa063d79a594a30dc6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c2d0cdb8779146178fccdfebd7f917e6bad384a4d74ff14f403c9abb49b9000"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba07786913aa6e65090755f3f4e314dd0adc87f6a8b72184ccfbbff0cd610607"
    sha256 cellar: :any_skip_relocation, catalina:      "ba07786913aa6e65090755f3f4e314dd0adc87f6a8b72184ccfbbff0cd610607"
    sha256 cellar: :any_skip_relocation, mojave:        "ba07786913aa6e65090755f3f4e314dd0adc87f6a8b72184ccfbbff0cd610607"
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
