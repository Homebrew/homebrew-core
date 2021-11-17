require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.5.0.tgz"
  sha256 "6b2d4346b0b29db835f0e7712c6a01fb366f96af26ce66a8a8774a5126b3bb5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47002a936c14c2cf121e9ced43a0e352ee1cd51fef64dc4d2b7ac08d9486cbe1"
  end

  depends_on arch: :x86_64
  depends_on :macos # test fails on Linux
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
