require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.6.2.tgz"
  sha256 "0839e480b0ea800091c9b6005397ad34390c6bbcc74e2e9c0f347907e7922b42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e9e1182c68ba32608d6a45d79e43b1623cafed5f9269aa68015fb97a19542e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e9e1182c68ba32608d6a45d79e43b1623cafed5f9269aa68015fb97a19542e6"
    sha256 cellar: :any_skip_relocation, monterey:       "cf223680cfa0f57c55925beccd0596480b78f32fd73d8beada3dcc26f7c1bd89"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf223680cfa0f57c55925beccd0596480b78f32fd73d8beada3dcc26f7c1bd89"
    sha256 cellar: :any_skip_relocation, catalina:       "cf223680cfa0f57c55925beccd0596480b78f32fd73d8beada3dcc26f7c1bd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e9e1182c68ba32608d6a45d79e43b1623cafed5f9269aa68015fb97a19542e6"
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
