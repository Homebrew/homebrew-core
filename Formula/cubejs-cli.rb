require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.34.tgz"
  sha256 "31708bd0b1d0d7688c26cd94ee0f109d635dff9af5adbeb33b005bf9d49b8732"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ffdebcb3dbb01b0cde499e3570661349f0333df72aa3fc9011a3bb454298fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ffdebcb3dbb01b0cde499e3570661349f0333df72aa3fc9011a3bb454298fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ffdebcb3dbb01b0cde499e3570661349f0333df72aa3fc9011a3bb454298fb"
    sha256 cellar: :any_skip_relocation, ventura:        "cd878608b2b50b7df3c8c71843ca4827c7c3ada37233a31749b229a02f05af40"
    sha256 cellar: :any_skip_relocation, monterey:       "cd878608b2b50b7df3c8c71843ca4827c7c3ada37233a31749b229a02f05af40"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd878608b2b50b7df3c8c71843ca4827c7c3ada37233a31749b229a02f05af40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ffdebcb3dbb01b0cde499e3570661349f0333df72aa3fc9011a3bb454298fb"
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
