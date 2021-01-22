require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.22.tgz"
  sha256 "acb176035bdd830f3c9d3d903dd6b3342d9efc96df1232e97d4f533c33a690b5"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3519142bef1bd5725f11aabeac2cfbddba1c6fae30f46ecf34d01f113e868663" => :big_sur
    sha256 "a20246f15c519e0654508949a20b7417d27f710910e55a29dc22b22529fe30b4" => :arm64_big_sur
    sha256 "7817626991931b5cafe5003b596f12e1cadf8a143fd0f8452f710dae0b190b20" => :catalina
    sha256 "618dfa24376ab2a4ee96b2cebd1576434d0da5a872f0a57729ee2e3b4567d52e" => :mojave
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
