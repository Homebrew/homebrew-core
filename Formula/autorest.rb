require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.6.0.tgz"
  sha256 "aa21f1abc78bebb586d59a5936222dade5981247e08edac211db56965165dca4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eaa1639b25a6878602092d78d3841e2f2c2f363542a60fb67d070dc403a3ab9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eaa1639b25a6878602092d78d3841e2f2c2f363542a60fb67d070dc403a3ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "b5fbb8a8239c44630d21f2633fec1f9c5f6ce6e203f020bbea61ede4efced4b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5fbb8a8239c44630d21f2633fec1f9c5f6ce6e203f020bbea61ede4efced4b1"
    sha256 cellar: :any_skip_relocation, catalina:       "b5fbb8a8239c44630d21f2633fec1f9c5f6ce6e203f020bbea61ede4efced4b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eaa1639b25a6878602092d78d3841e2f2c2f363542a60fb67d070dc403a3ab9"
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
