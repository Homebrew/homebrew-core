class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/cf/54/8923ba38b5145f2359d57e5516715392491d674c83f446cd4cd133eeb4d6/jsonschema-4.16.0.tar.gz"
  sha256 "165059f076eff6971bae5b742fc029a7b4ef3f9bcf04c14e4776a7605de14b23"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "793d71eae260c6aaa47c70a3c8c036477d51edff2a938883bfec2e73beba3e15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee3aacf2bb26e5033f089b2c3413a06f83d0c8c0a28743ba4a811dd1c6e6513b"
    sha256 cellar: :any_skip_relocation, monterey:       "34e5e303ca1f24926a40456dadf1ae91b6760dfe9080e9ab6c36e9f90795d082"
    sha256 cellar: :any_skip_relocation, big_sur:        "3829eef29b4bf938227f0d6680176252449c489c20429a52b7035d55381fdcba"
    sha256 cellar: :any_skip_relocation, catalina:       "a6747b964a307b0daa69ea1f9419076953cdcf27753811598977aaaeb3b8916b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d65999026c5ebb7607b3123fd87ad623b0c9a031f4849c72a9019c8e2e7ed0"
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
