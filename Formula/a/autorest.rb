require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.6.3.tgz"
  sha256 "d6deb4c56e1e6e2afd802a73f1f3e5654dc81f05528b85b085981ed3e7dd4236"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b4915255e97fe2641111b8dadb313951bc66947513bc3785933ec58d154d7ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b4915255e97fe2641111b8dadb313951bc66947513bc3785933ec58d154d7ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b4915255e97fe2641111b8dadb313951bc66947513bc3785933ec58d154d7ee"
    sha256 cellar: :any_skip_relocation, ventura:        "fe4ddfb4c7b22e1549e2cf91d3ed9a1d7f773175cbf2f2b706994546afe876d0"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4ddfb4c7b22e1549e2cf91d3ed9a1d7f773175cbf2f2b706994546afe876d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe4ddfb4c7b22e1549e2cf91d3ed9a1d7f773175cbf2f2b706994546afe876d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4915255e97fe2641111b8dadb313951bc66947513bc3785933ec58d154d7ee"
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
                               "--typescript",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
