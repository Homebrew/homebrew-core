require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.6.2.tgz"
  sha256 "0839e480b0ea800091c9b6005397ad34390c6bbcc74e2e9c0f347907e7922b42"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51a39e452f112f91d8bd1ac7e9e9cc2f5d1612a12d28d361834d1764f01351f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a39e452f112f91d8bd1ac7e9e9cc2f5d1612a12d28d361834d1764f01351f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51a39e452f112f91d8bd1ac7e9e9cc2f5d1612a12d28d361834d1764f01351f2"
    sha256 cellar: :any_skip_relocation, monterey:       "3932fb81b47d69a39aad649dd24e2c5b0e264fe88d44d35e9a27c0a68238dba7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3932fb81b47d69a39aad649dd24e2c5b0e264fe88d44d35e9a27c0a68238dba7"
    sha256 cellar: :any_skip_relocation, catalina:       "3932fb81b47d69a39aad649dd24e2c5b0e264fe88d44d35e9a27c0a68238dba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a39e452f112f91d8bd1ac7e9e9cc2f5d1612a12d28d361834d1764f01351f2"
  end

  depends_on "node@18"

  resource "homebrew-petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"autorest").write_env_script "#{libexec}/bin/autorest", { PATH: "#{node.opt_bin}:$PATH" }
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
