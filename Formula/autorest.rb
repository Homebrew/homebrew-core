require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6334.tgz"
  sha256 "b6fbe017c4dcc312cc9363bf5cff7e2681a7c26759b8d41f8d5658ecdd9cc1dd"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6bd629d437c275af54fb58ff002e774de71773d9485d12cf3f265908fcef7188" => :big_sur
    sha256 "ba5b71f77101933437af2a692f6b2c3065c3b860181266c4382227993b0750f1" => :catalina
    sha256 "4d6cfff3440a66fa017e8532ce64d93ff9dd73a443da6574d37694825e6dd0a0" => :mojave
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
