require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.1.2.tgz"
  sha256 "35dab2c64d9e5e67a5f0326dd67614503a4bf012356515e7aafda599432cb596"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "927a6e44937059f91ce985810108a9f95c3594a51b229d4874433134fb96cb15"
    sha256 cellar: :any_skip_relocation, catalina: "cb0c10fce9f1b39d3ad0e49689c380ff4e9fa097661a28d59f2f23d8e23a2685"
    sha256 cellar: :any_skip_relocation, mojave:   "a4d6f18868c15478960951af4a3af663ceb0c9c22f011e5b615051e3a815cf58"
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
