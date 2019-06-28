require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5224.tgz"
  sha256 "b6b842c22f4da1b30ad03958be70641380eabe5dcf952e8a65713f7d97f09e8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d52f83955789ff95fbfe3e2365e4a3a18a59be32d5c28d616486ef44980788bd" => :mojave
    sha256 "79b3a28216662ce5769a785cca193100228f06043df8eed4ad96f8d8f68c9e7d" => :high_sierra
    sha256 "74a0a9b1b3d189fbec9a8c824f9a899628936b97f538779b1a8f0711ac53cb6d" => :sierra
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
