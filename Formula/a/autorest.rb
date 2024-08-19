class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.7.1.tgz"
  sha256 "fe148defacd8f859b6f1fb9284e4ff685b242a7581452a1c1b432b5d8c528ee9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30a9674e336cdda3efd1f20619c0fe0064756580ddad82f8fb5b644f70c047d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a9674e336cdda3efd1f20619c0fe0064756580ddad82f8fb5b644f70c047d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a9674e336cdda3efd1f20619c0fe0064756580ddad82f8fb5b644f70c047d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9541dfcb6f0bdbf17e71c29691892f82a76e86bf54c15adf7d06ac34862df3cd"
    sha256 cellar: :any_skip_relocation, ventura:        "9541dfcb6f0bdbf17e71c29691892f82a76e86bf54c15adf7d06ac34862df3cd"
    sha256 cellar: :any_skip_relocation, monterey:       "9541dfcb6f0bdbf17e71c29691892f82a76e86bf54c15adf7d06ac34862df3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a9674e336cdda3efd1f20619c0fe0064756580ddad82f8fb5b644f70c047d7"
  end

  depends_on "node"

  resource "homebrew-petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *std_npm_args
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
