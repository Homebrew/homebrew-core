class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/26/67/36cfd516f7b3560bbf7183d7a0f82bb9514d2a5f4e1d682a8a1d55d8031d/jsonschema-4.4.0.tar.gz"
  sha256 "636694eb41b3535ed608fe04129f26542b59ed99808b4f688aa32dcf55317a83"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded88bff3b34ad29a143738035a767a05c76e3a219d8004121e2a2fe43bd8b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e14f0f4cf93413a92a111fe18394972feb7e51f7c7d810f7138fb3fda014bf93"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf5a16ce2217a705f5421cb1b8613a976076b013faf5cb55a160c0b9e232a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff6739b1b5f76d375a5617b23e218454a83ef4913a058927145ad8473d412041"
    sha256 cellar: :any_skip_relocation, catalina:       "f539b38c3b87ef97986b32eefe0add96df48fbe74b6f6653d294d5fc83cabb05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29bdb43d22e10691d64c2f13bfba83f86cbec9b23274bcb1ad2775a89208318"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
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
