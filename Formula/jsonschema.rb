class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/6b/a3/06e04a9f2a5de37b75c7b500ab3d6a6dbf565ac83b142054f75dee9f527a/jsonschema-4.3.2.tar.gz"
  sha256 "cca171fb7544de15ccda236bf78d58434d769c9a2ce21d44e0d209e39eeb8876"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5d59a5bfeedba56de728de648dfd41fdd55c91076bee749175ebfb25fcb79a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c601caf8a837dffee6f6f30ead31d8351513bfda9386f420e48fc74d0771168"
    sha256 cellar: :any_skip_relocation, monterey:       "427f232a47584cad18a0979c93a04fbadce9b97581755430118b6c4d046b80fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "a61ace309e5c74697a91d99826a1c880fbbcd89429707a1dab569d47546b8985"
    sha256 cellar: :any_skip_relocation, catalina:       "8afc884cdf6ab20ce980a9a6370cbf8c64e24363920aa1ce122d848ac5e838f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba9def9b4317a326d45e42904aa0b5923f73450ff1981558cf6c1c50ee53ebd"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/jsonschema --output pretty --instance #{testpath}/test.json #{testpath}/test.schema")
    assert_match "SUCCESS", out
  end
end
