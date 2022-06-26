class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/b5/a0/dd13abb5f371f980037d271fd09461df18c85188216008a1e3a9c3f8bd0c/jsonschema-4.6.0.tar.gz"
  sha256 "9d6397ba4a6c0bf0300736057f649e3e12ecbc07d3e81a0dacb72de4e9801957"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2394636d31f0971669e6d6c21c03ba7038ba42bb2cc2c33d36c4fdcf7b544ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3dbb106f055de33ddbb7e28c0e39d664b5207f83194dd943ce46ecc04674cec"
    sha256 cellar: :any_skip_relocation, monterey:       "b8fb63ea0dff4f52bf12bf4637af72ec41cc977827d4e6187afa1ff8c5a6df5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e96216bb9f565e72dfdca6c3280723dd7abe26a00c37116b9db845e606ca502"
    sha256 cellar: :any_skip_relocation, catalina:       "94da2e519bee0f1b30a3960c68a8f9317267f011db9de42ef4188583fbd9ce76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6e3cfc2288107a84c0cdbd02ecc7535a0a90323feb117af3d02bba0cbd46dc"
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
