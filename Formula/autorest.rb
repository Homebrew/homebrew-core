require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6322.tgz"
  sha256 "5ff0066889b5695a7711ca935d5123adbb60cbc861a4b736cb027a16f0bc9b07"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "92e13d900f95ccdfdb69fd7d7c9f25b00a3869e8430b6593b73698881232f707" => :big_sur
    sha256 "873f18db2ce344e8d3cf25739ce1a599bcf59281a20cfd41d84ee21ef241b743" => :catalina
    sha256 "ada0e2e906e92d33c1c25f334ba9c79a5ee121fa76c2635b1d3193820da9829e" => :mojave
    sha256 "d6d5512632391749f56e1aa6cc246f8de9d505425be1553fc5f5d42a6a04e98a" => :high_sierra
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
