require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5228.tgz"
  sha256 "cdd69ca16a2223c7a3a2cfdc64d3a32183c181fcec77d824f3da82a255406f99"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a733987c3697be46e99912c3c86ddaa8093e41ce544fe2d3b78d94727cc6079" => :mojave
    sha256 "91d12305931fafaaeef51415db64526c5ae6df78f67511998c98a2498ef9a433" => :high_sierra
    sha256 "69807952f97305180d1fdb2738c580109e66f845a7e5900b54c708114e7e3eeb" => :sierra
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
