class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/01/75/ffa9d859f2cc2c4a868fa297f1b485fcadb0d9cd7cf3024bb7f4b68d2b8d/jsonschema-4.7.1.tar.gz"
  sha256 "25203dbebd62a1179f810f14339f7a638baaf279b5cc3b738a58c3744af56d65"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "340857f235559f134515ebf737ddc0b33722d5bdc1ecb4c13970f854275abe57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a68e211974a423dbe3cf8e44b4e75646801f7be2c5477baecca2c963dbac0cd"
    sha256 cellar: :any_skip_relocation, monterey:       "27ba142c74330322713feba40b9482d49b10e5d7efcf880c409cb950e15b18a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "afd59894a7855f13d529874b8c4fb9e700922171e5418f63a0c02c8d2b16beab"
    sha256 cellar: :any_skip_relocation, catalina:       "e274d3d199df931e6a3fc3d868a257c3e80acf5f88734e90a4f6d7207decc2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb54323aca2b736792d9a5d73a0bafb1bde432900715655778086e46d4f3eb8"
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
