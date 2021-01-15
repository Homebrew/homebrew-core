require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.18.tgz"
  sha256 "2b773915e3c98ed89e1602ae9b344ffb330249ac6acc021765b7cc0249147e06"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "710bf697da11f7b64d2f8c013c91341a3e0c25932ccc5785b272c14757430516" => :big_sur
    sha256 "76a893047848d1a1d12e6246e505206970b546d50b9a11d94ddaf7bcd81523cb" => :arm64_big_sur
    sha256 "a07fa0f9209db21217cc3165638dc5cfd530b5d511ae09a6f239e10ea709bb51" => :catalina
    sha256 "daca379b758053d539cabf9d5f005d829b1869275095626d0a66e8b13e000fd1" => :mojave
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
