class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/9d/c7/213df24d4dcf2eb115e2843205c6073c192976684388d6912cf674db2b8a/jsonschema-4.8.0.tar.gz"
  sha256 "c1d410e379b210ba903bee6adf3fce6d5204cea4c2b622d63f914d2dbfef0993"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41fe96ccabab5b90e5023c1077be28fe716d12fad98ad0b127d3cdc53d18eae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db4cd67a470103911a30e741cb0c7ddb7e34ed28ea063b0a35085601e6139722"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d6f43487121067b252daa89c616554dfcfdeadff1a3ab7f9b2161537d4274f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e9ae96d595e70a1a336c44c4a21d7e10dd1e38fdaf7538201a2a9698da0fbba"
    sha256 cellar: :any_skip_relocation, catalina:       "b42b1bd1824acec8027295b5406160039ad86125b0da266f629db38b9c1f2343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9da0ceb1967ec25abad0214db671d25498e7a0e665728b82b046828bada670"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
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
