class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/35/ee/889aee424a43066a06ac68e499335877775eac9b4409f7860f6af94c6688/jsonschema-4.14.0.tar.gz"
  sha256 "15062f4cc6f591400cd528d2c355f2cfa6a57e44c820dc783aee5e23d36a831f"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92b1d3e54b1eafdd001e0de2df6e550071ebacef16cde27a0a014f2d7a4b61e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c57449d2bf0af7bf64105041ae2aeb7465228a6a3a01751b1b723ec308b2439f"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c861fab56b57648104007260515a31b4214928deef871ea214d2f7d6b1fc8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "11015c4194a7898ce9ad823ce3bbe5331a730a96729f415d70ffbe568586efa8"
    sha256 cellar: :any_skip_relocation, catalina:       "246cf9c5e1448ac207728fbbab43b84deb3ea2947c20a6258cd3ec30d6daed19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8aa938f77268afc1ac37b8e6f529606250f1c6ef390fc725e7fe92f5994902"
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
