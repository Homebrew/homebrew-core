class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/7c/0d/d19c78ccd17814818497fb4be515638fd707afd98d7dc102f0ad7297e0da/jsonschema-4.15.0.tar.gz"
  sha256 "21f4979391bdceb044e502fd8e79e738c0cdfbdc8773f9a49b5769461e82fe1e"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c653f4e702c1d1e11d8a3cf3f820d273567c03ee64717e86fcd697c647d8c9e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3528eb956558453cef9fb847a00a8203ce587f6e8aaa2c99873411eb364f6a6e"
    sha256 cellar: :any_skip_relocation, monterey:       "f81cb06eef9d01d5c66d6ff2a05fd98382a16308f208ae7f71be60695db066ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "dade631f6dbef67ace8ee9a064b5117f0459fcc3210b492581f4b087da4634e5"
    sha256 cellar: :any_skip_relocation, catalina:       "9831b5667b7404278844f24243e76bca7f735e867aca78fd37d1e29ddd193756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "835ffbba66228eb40a6e15374a413d280a74625af0d6ea33e6f724bbcfa8bfc8"
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
