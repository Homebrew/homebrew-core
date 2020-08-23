require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.19.51.tgz"
  sha256 "2022d2f7614e0354e4294252c17dd93dc938251cc30a309c16e1741164aa9f7d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "09eb746ab289c0c927479233a4a4e5ddea5513db8e1824e9391efdece6abe126" => :catalina
    sha256 "b2f5f307bca4c14051b0ae10c7cad83fad42796658cf0e20c268eb150dba3002" => :mojave
    sha256 "2d52046cd64b4af60c833242540f629003b816947f5d5f72af4bb35a32491c29" => :high_sierra
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
