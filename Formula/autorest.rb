require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.5.1.tgz"
  sha256 "3361f0cf71b7013efb38376f65f973f0dfa83a86a59cfb749380344bcea8bdbe"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af3dc683e96f877de0ba31239fd11c01649e6306066fd7cf804ebacf9f0de62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7af3dc683e96f877de0ba31239fd11c01649e6306066fd7cf804ebacf9f0de62"
    sha256 cellar: :any_skip_relocation, monterey:       "9c8d4687059deeb64c56b99eece09ea5004052fbfbed3a291222e78ec58424bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c8d4687059deeb64c56b99eece09ea5004052fbfbed3a291222e78ec58424bd"
    sha256 cellar: :any_skip_relocation, catalina:       "9c8d4687059deeb64c56b99eece09ea5004052fbfbed3a291222e78ec58424bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7af3dc683e96f877de0ba31239fd11c01649e6306066fd7cf804ebacf9f0de62"
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
