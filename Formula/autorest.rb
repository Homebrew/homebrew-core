require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6338.tgz"
  sha256 "28c1fb3d51629ef2a5a2ac7598a306ca6b398af17853189148feee66baf6b015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c3fd2567d1d0e80fa3db5d78382ea4a9948ca4d30e6da13ce2851c4e5d114852"
    sha256 cellar: :any_skip_relocation, catalina: "95a0b86206adeea3f718bbb7df68bd943c1992f5c3247a9af74e1a38d803060c"
    sha256 cellar: :any_skip_relocation, mojave:   "cb46ce8b659f3c61447b9327cbb58e63cec960f367818ad9171ec5efa301ece5"
  end

  depends_on "node"

  resource "petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--nodejs",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
