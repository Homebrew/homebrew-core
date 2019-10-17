require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5231.tgz"
  sha256 "85408c578269e5f049a73d1ac288a076d560103b2257afd4eda27ef8ab1a23b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f41ddf8f8218e4ed8e284e748578f51c6c24c1303087c5f910854e7a689de900" => :catalina
    sha256 "a72d5b53d1f21808a82669db04af966810c3d674ee62c89dfd3e3fb40f212e98" => :mojave
    sha256 "61f7cad35d9f06d88c663eec5dac5b77535c4d98a6d8a45eede24d8996f2db39" => :high_sierra
    sha256 "1c22864679672ac81c6636af29f1b49c2d77e12fd9a699da4a5a93204de83d98" => :sierra
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
