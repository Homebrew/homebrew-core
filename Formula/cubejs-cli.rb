require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.25.tgz"
  sha256 "2b44864bf211a3ffaf3ece1e120bb06042015df86f1f45a8d6e493950ac343a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "318d3ab750bd84c502f824a6347e8b74bf3dd4031f8a7690f1cbac7e15b69745"
    sha256 cellar: :any_skip_relocation, big_sur:       "5740c763a4f4249b321a1f85b75b450b9cfba982dd419975a39032106f968dfb"
    sha256 cellar: :any_skip_relocation, catalina:      "753d49357242bcebac7520dd11460a211163e98265e137de71f019139e5b0383"
    sha256 cellar: :any_skip_relocation, mojave:        "53896322b374b3c827c736fb2fd6e1103bec52f034936524fc81689f296c7e6c"
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
