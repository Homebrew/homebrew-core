require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.40.tgz"
  sha256 "58b4b053e36dad91222dd21e664180082a8bdc83b26dde82542ad04003f25a6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f4550dc120e3d5e675d725552d6bd67c88217914b2064ba5c7aefa2bfd2b83d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f4550dc120e3d5e675d725552d6bd67c88217914b2064ba5c7aefa2bfd2b83d"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a56916cef2b038b6e624726ac7a948389ddfec5fbcadcdf2611e8fdbb1ef68"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3a56916cef2b038b6e624726ac7a948389ddfec5fbcadcdf2611e8fdbb1ef68"
    sha256 cellar: :any_skip_relocation, catalina:       "a3a56916cef2b038b6e624726ac7a948389ddfec5fbcadcdf2611e8fdbb1ef68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4550dc120e3d5e675d725552d6bd67c88217914b2064ba5c7aefa2bfd2b83d"
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
