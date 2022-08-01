class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/02/96/901e5735f16cb438eccff95b534d0bdd058237dab1ae4731b5e1e1ddc9b4/jsonschema-4.9.0.tar.gz"
  sha256 "df10e65c8f3687a48e93d0d348ce0ce5f897b5a28e9bbcbbe8f7c7eaf019e850"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7b54959686945e498599a5c629c2c27e5970eed12363d2fbaccb4543eb83c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc9a5243fd2d5076b43ec5de8d019d3292601584d8a5b2c763d03ad463482597"
    sha256 cellar: :any_skip_relocation, monterey:       "88985c86562a555d16be6a7dd0612ec93b7a5832b207ba64362ae6cbc9e9d51c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9e3f59b87a6b95f637c26265828e38b5f106ce4d9d463d99ef4d51cd3f8c7f5"
    sha256 cellar: :any_skip_relocation, catalina:       "e65742706193fda3c1d151ded62890935b5addca4e251340a9d141ba8d2af749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97545bef9ec6d56bb06e680ef8ffafc93bbbbcfa1a070018e131b019aa025b97"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
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
