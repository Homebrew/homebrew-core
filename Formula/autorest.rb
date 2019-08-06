require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5230.tgz"
  sha256 "561ab8deb08c8f4c3fa70e07ef29a383d60ae5ea0f5bedb20f16fff5f067bb4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d9849ec2158acec5686aeea1bc90c6a687969b2346646faaa1b64a44434b33e" => :mojave
    sha256 "5163c05a4319d665b03f14518d389a53132ff02aec758e8b7bc9ecc35dce5aa0" => :high_sierra
    sha256 "fc52802572953cecf95d0f9a0d9294fdd3bb429cf7003bbd13820d637ac23676" => :sierra
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
