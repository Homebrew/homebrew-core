require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6187.tgz"
  sha256 "57b243a0dc543d55085503d33679f662a3cc3ea050ec502f155381d9cf61163f"

  bottle do
    cellar :any_skip_relocation
    sha256 "57c6f4f501c99c24ca7b35a09ef21663ab437470386c1c90033f0ef9e0612500" => :catalina
    sha256 "c94c2dca6cb5bf911f854b3f0f104096cdebb85f7ae481c480354d7f2ca01308" => :mojave
    sha256 "e875bf8bee3b62577f260233d0a5c841c2f83f9ca770f2070e4ace0e07a0062f" => :high_sierra
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
