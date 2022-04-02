require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.39.tgz"
  sha256 "595b0666f3842f6fd370b04a8da717829db479d98d76a7decc7ac01e6671c802"
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
