require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.2.tgz"
  sha256 "aa16414f9cb33996596d64189a71b952d262fae5d689587f9fa309d001f7ff70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2780a1bd4cc260a581924874ea3b2e9599fdf9851c252924b8766fba37aa65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e2780a1bd4cc260a581924874ea3b2e9599fdf9851c252924b8766fba37aa65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e2780a1bd4cc260a581924874ea3b2e9599fdf9851c252924b8766fba37aa65"
    sha256 cellar: :any_skip_relocation, ventura:        "3c33911503f40cf4a53487a5785fbf5150c270a3d53761fe7c0aa77bece87630"
    sha256 cellar: :any_skip_relocation, monterey:       "3c33911503f40cf4a53487a5785fbf5150c270a3d53761fe7c0aa77bece87630"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c33911503f40cf4a53487a5785fbf5150c270a3d53761fe7c0aa77bece87630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2780a1bd4cc260a581924874ea3b2e9599fdf9851c252924b8766fba37aa65"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
