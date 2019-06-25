require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5221.tgz"
  sha256 "8e93ad94565c915ef292cf294e9d36ad40b032f73f7cc04a57cb188611a8ac6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f876ec85254016d266e5c194b1438ffeed42e789efed5a369f298ebb417cdfb" => :mojave
    sha256 "be830d2ae2ed14ddaffdf16b4f69fa184460469d7ad6de439b8b69e58b0b22e0" => :high_sierra
    sha256 "60af123b9d4afef0fd26389191e722ae66d49c1acc0251c284d806c4101f0cf8" => :sierra
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
