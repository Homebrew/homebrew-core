class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.7.2.tgz"
  sha256 "4bd274127b60c276832127fe738f0f7f25ee56b190395dc4d594ca507659ccd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6840e5f417fa145ce6576a18e7c82e45f866ea344555b58c06a35ac88fa47b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6840e5f417fa145ce6576a18e7c82e45f866ea344555b58c06a35ac88fa47b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6840e5f417fa145ce6576a18e7c82e45f866ea344555b58c06a35ac88fa47b66"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1c3cc8270cdd3353fb2ee10ba5c5023351c6ae8eb7d291f97a3685c116576a6"
    sha256 cellar: :any_skip_relocation, ventura:       "c1c3cc8270cdd3353fb2ee10ba5c5023351c6ae8eb7d291f97a3685c116576a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6840e5f417fa145ce6576a18e7c82e45f866ea344555b58c06a35ac88fa47b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6840e5f417fa145ce6576a18e7c82e45f866ea344555b58c06a35ac88fa47b66"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource "homebrew-petstore" do
      url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
      sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
    end

    resource("homebrew-petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--typescript",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
