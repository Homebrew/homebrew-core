class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/42/d9/bfc795bb02d0cee772f7b339c5aa6fdd8778e852951e62603556d6143fbc/jsonschema-4.6.1.tar.gz"
  sha256 "ec2802e6a37517f09d47d9ba107947589ae1d25ff557b925d83a321fc2aa5d3b"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c692186ee8beb483eb23ae4df08e06816f3550d3171a496c725afd771de5192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd10de0482c4561517a8aa868542bf6919d97c4d0de9c51ad33cc95fe7b8fc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "227be6b2620eb0602fe8e19f675afc37df4c995d9257d60268cd7d0044364cbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e9acbcaffe695b057843b2ffabcc8f96612a418d1150112abb42a57ef8cfb57"
    sha256 cellar: :any_skip_relocation, catalina:       "04e05f188c38ab2551bf63f5bbcc83d51263bcf869dc507b9dc82ad887377348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a021a5557af11763aea8c0377976eae5f2e8094527957ea4ccfeedc50cb95ebd"
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
