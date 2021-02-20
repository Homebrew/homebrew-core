require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6339.tgz"
  sha256 "8ec0349835b9a293b43a7c4dfc62ddb92a819576802ce4618f9a2824c3c54d66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "63a04c6ca08945a2767f7c533b54a291f4b01bc74e6589ec1c2548ae90fd3d5f"
    sha256 cellar: :any_skip_relocation, catalina: "aa4558330a13eefa11bd986c0e678e54d8758e6e9511a0933b9a110708584fe8"
    sha256 cellar: :any_skip_relocation, mojave:   "59277585bc2642dd99b7fab45269648fbd9efa17135437b316ac727c6fd26a7e"
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
