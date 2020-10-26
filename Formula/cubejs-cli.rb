require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.22.2.tgz"
  sha256 "88e8a404aafa50dbfed288273b09d6e28afc7486d25820e427423e3cfee3d994"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3be2b3c9ae7b98709af1fd13c9234e546a4184ce925ebe1e3f37ad3295818b11" => :catalina
    sha256 "b5b4191ae409eb61afda90dbae72a0269b5a6321de572d354bce5c04d5cb545e" => :mojave
    sha256 "37554282388196038e6ea97fecbe99a86967ea88cdb5c7973e3791465178b787" => :high_sierra
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
