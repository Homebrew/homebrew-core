require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6336.tgz"
  sha256 "75a6b6221ca9fd7a3e009db7d4f4f5400a90da108f5eee3dfec287aa58f1e39c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f20d2466f28d72885326c2927fdd36f6ff7231a9efba614cfeb953c63835fc76"
    sha256 cellar: :any_skip_relocation, catalina: "eb98c42be7be45da31afbd998dcf87a6a707aff9a626c8356c96031753f6abdd"
    sha256 cellar: :any_skip_relocation, mojave:   "12688e41e450d80aefee3d28891a08c52762cf2bef24a28f51cf1eeabd93f3c3"
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
