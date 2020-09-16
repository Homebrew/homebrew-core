require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6247.tgz"
  sha256 "cbb09fa566c2e757e168e8bc88db4eef96196a6191cb11d807460fb542c186fc"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b59e9e1c211b3e15c02f00d37d7b956add5842840adcb8f99a9e7e6ec1fd82db" => :catalina
    sha256 "ccc037e7a371167f99678cdc5e08e17e9757978b26baffbd619e803a28888435" => :mojave
    sha256 "c860ebc4a03df7093174e7ba61564d71f5d9d4b3411dd11e2ec55af95020d877" => :high_sierra
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
