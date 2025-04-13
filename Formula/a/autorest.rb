class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.7.1.tgz"
  sha256 "fe148defacd8f859b6f1fb9284e4ff685b242a7581452a1c1b432b5d8c528ee9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e83b47baa0ca32e782bee30fb9370448ffc422da79bc9e908456cf1703e1e80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e83b47baa0ca32e782bee30fb9370448ffc422da79bc9e908456cf1703e1e80e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e83b47baa0ca32e782bee30fb9370448ffc422da79bc9e908456cf1703e1e80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a723686fd868adf61661dc45f12e286dac112866af987abb041ad828aad82988"
    sha256 cellar: :any_skip_relocation, ventura:       "a723686fd868adf61661dc45f12e286dac112866af987abb041ad828aad82988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ffb4481a753a24a50ec78c9ce070b516f7ebdce473b829be961c172b763370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e83b47baa0ca32e782bee30fb9370448ffc422da79bc9e908456cf1703e1e80e"
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
