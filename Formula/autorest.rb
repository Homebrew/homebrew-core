require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-2.0.4283.tgz"
  sha256 "a655719fa6dd20b11db4a3d9c5853e9ed0454429bd6371f0bc6a5a9014b1bb8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f21d55c75239c873ebaea6f35b98e55369587f0d1c1750dc9fa5f0b5961e1be1" => :mojave
    sha256 "755f3e5566c192b4f861a2e8dd4f2d2351070a1d022e54138197aae55b5a894b" => :high_sierra
    sha256 "ddf3e62ef8e0c98554f48dbd2ac1aec6c56ae62b20419c14b049063867183cc5" => :sierra
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
