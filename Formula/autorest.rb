require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.1.4.tgz"
  sha256 "48ee61219ff3a66909621fe19820905e0eea30bb5b5e278474911c3bc31a9847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a54f7138dd7d82c455b0b666b427a07850025031ea8a7b3ca06b7d8358f2f841"
    sha256 cellar: :any_skip_relocation, catalina: "6ba0ba2972f4e5ade8decc1b6eee4dee11ea031200d040e447415cfc622c6162"
    sha256 cellar: :any_skip_relocation, mojave:   "5ff05a03dcf6e6ae840f523c71ccc5a5809e2cab6a76b8196661cb22f7c4c4b1"
  end

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
