class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/3a/3d/0653047b9b2ed03d3e96012bc90cfc96227221193fbedd4dc0cbf5a0e342/jsonschema-4.17.0.tar.gz"
  sha256 "5bfcf2bca16a087ade17e02b282d34af7ccd749ef76241e7f9bd7c0cb8a9424d"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6466b0da0224a6032b11ccb946ae9621c5f1dbddb54c86055965f24780805d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "837810d192217865aefa25421554fe02709019060faab5f6317042f1cb77ace5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f78327ca1a3d89ef36bb37bff5d4904021dd73f8678f821c849adf2d053c0355"
    sha256 cellar: :any_skip_relocation, monterey:       "5515829f57e8627cf12ca65deb0b1d9e24505d4fe89ab22b1269503eaa71f035"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5a56f030e45673a6b333366b67236c488296613b9504a39f64314f81010886"
    sha256 cellar: :any_skip_relocation, catalina:       "67d97e992ab442330ab427756db36c100442477e7413eae06311f5b568d0f127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d718d98a8eb62223df48171c50bba9c36cb8ffef721c203fe96464f778c2296b"
  end

  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/19/fb/845ff3b943ede86c69e62c9b47c0e796838552de38fc93d2048fc65ba161/pyrsistent-0.19.1.tar.gz"
    sha256 "cfe6d8b293d123255fd3b475b5f4e851eb5cbaee2064c8933aa27344381744ae"
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
