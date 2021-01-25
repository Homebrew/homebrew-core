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
    sha256 "e3f2d66e6ed1b2dfea9e6e3f08183491f7b932e6ef7c4298bb60035336c50359" => :big_sur
    sha256 "00a0713721a3cc9ba3001d5f31b7c8db5e65a41a978596c7da1dedb8bf347902" => :arm64_big_sur
    sha256 "6ba979073fee83a9d8e52ec46512a115440378bbac384529c0686496e0a7d744" => :catalina
    sha256 "89d4020717d7cd82fcced28045f5aaafded218fe3c3d5b98b2239e2aa59ea27d" => :mojave
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
