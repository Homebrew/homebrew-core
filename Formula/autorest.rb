require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6335.tgz"
  sha256 "ac38bdeb9f5a5586c720b142f09d306a4210789a32989f185379909d3e788ae5"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "20f220b18efa91377e8523af98f72243c95a21c16a8da32ee963730a52ca5752"
    sha256 cellar: :any_skip_relocation, catalina: "687e9a00a44802f4859ff54e5670ef8e40dc64c40678b9c637014d542e0a467a"
    sha256 cellar: :any_skip_relocation, mojave:   "cb69d4fa61cf72ee01a718c3322f8dc82fbf3d3682a4d06d5712af0180207f61"
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
