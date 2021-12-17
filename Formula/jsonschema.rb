class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/5e/5c/3ca913d9cf27475ea231f79ee398af9b1082cbbb4f7e46c243446e7fe169/jsonschema-4.3.1.tar.gz"
  sha256 "0070ca8dd5bf47941d1e9d8bc115a3654b1138cfb8aff44f3e3527276107314f"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00fc295dfe73b47a8e90294baa193cace61103790ec906c329e15252dc717949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d52c722e61f0b6475666d7b1c1d29ea61f2b68e6a2e2d3a39d0d79c9413586d3"
    sha256 cellar: :any_skip_relocation, monterey:       "b85fb9cc798d8c82a540ee9e04d286d40bb3ecd1e41d31bb75be8873fa0b8815"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd6d335bdd91b85d0fa0db77a47c93b76b3e0ecab5883665d23145d559b08ccf"
    sha256 cellar: :any_skip_relocation, catalina:       "837a1f0ee7d071612e8e4f9a9d8b2edfe2788c7d5cd847354bbde9aea1479024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abc44dbe4622897431b723b82f55ea9dee13743418390a8d58b93faa5d62cdff"
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
