require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5230.tgz"
  sha256 "561ab8deb08c8f4c3fa70e07ef29a383d60ae5ea0f5bedb20f16fff5f067bb4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d63a7e6db78df7e06eb953879e5c0c9176baee974bd72cde7fdb0f6355d75c27" => :mojave
    sha256 "682fd7b1880d2f44ceb9c6a361339b35f09c5b593caa40dda9bb906a54534f16" => :high_sierra
    sha256 "aae8b2c8607b2a4fdea74e677a13386d32dc7695a2787e72bfb8f43c73e65746" => :sierra
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
