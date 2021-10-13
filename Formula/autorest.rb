require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.4.1.tgz"
  sha256 "0fea952adae8d60ec2eeb5aade8f4faa9df6add9d39a8114e83f111bf9f9a1e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44c7f269ae1056c3e3cbe1752301db1d957ce16fbe6fcea5d864439e3ff1dc6c"
  end

  depends_on arch: :x86_64
  depends_on "node"

  resource "homebrew-petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("homebrew-petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--nodejs",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
