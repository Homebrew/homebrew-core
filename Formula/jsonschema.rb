class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/b5/a0/dd13abb5f371f980037d271fd09461df18c85188216008a1e3a9c3f8bd0c/jsonschema-4.6.0.tar.gz"
  sha256 "9d6397ba4a6c0bf0300736057f649e3e12ecbc07d3e81a0dacb72de4e9801957"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9308909fee150d682a7133f23b0614cc624323fadc5d22a764c7ebd9af821dc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea95ab61e608fdfd1b79021cc8766915a5b09d676a262e56f14856c529be0a8e"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0c1c1a1e593e2c09c7df92770a76c4c6606ac751f230578de751b9dfe2b9af"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c8f01595558ace96007e95e644acb39a328389fe344acce7223ee8e0587d7e"
    sha256 cellar: :any_skip_relocation, catalina:       "a9183acfd7bba207bdbb1d82e0d1d37ec13c1300b9686b653d9883ad977b6fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d4bed05c4f9c1337d961458516d223993e73429afb31fb12fe7f7346fbcbad"
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
