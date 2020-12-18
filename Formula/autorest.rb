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
    sha256 "eff9b827066f26c4e710fa9abe24a480c1cd868c189453d86404dcd73076fb0c" => :big_sur
    sha256 "6059b02cd613e0fb8e6a822f0a8e4e3f634a594155cb7a088b798197211f5993" => :catalina
    sha256 "2c7f9212e6af7f2d2323c9cc0dc396ae9cbfa66b00a6b11328ec7d3d5c9fdfec" => :mojave
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
