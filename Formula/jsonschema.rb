class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/9e/62/93a54db0e44c4de57868a7d638d7a8abce113c8bc43a20b10b1109b2a517/jsonschema-4.5.1.tar.gz"
  sha256 "7c6d882619340c3347a1bf7315e147e6d3dae439033ae6383d6acb908c101dfc"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc0fe720f1619eb3f4b1b1b5825d59848005d367fc6995a2df43900badb7647"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b73617ab4acd2b0ff99e469c7e8471ef12c269496b9fcce52c041b966b3966"
    sha256 cellar: :any_skip_relocation, monterey:       "e61ac8db949209f82413e1b836cfe05634d8589c67551c3122901732f90c1792"
    sha256 cellar: :any_skip_relocation, big_sur:        "540b9dd4c5f74774b0562559de59b20d323f8c8b010da23685660e2640f03be6"
    sha256 cellar: :any_skip_relocation, catalina:       "341115d1c8940bf502c5b726dc1e544e0c66e89879cfc7fa309516e3cf1e9ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d740f15189ec976eb338949bf1c3b5029ba5b87b334896597efacc23562319de"
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
