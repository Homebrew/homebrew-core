class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/bc/fe/b6abb45f1336458a4b9c86697c4f012fd62e92b22c73762935e3d68238db/jsonschema-4.3.0.tar.gz"
  sha256 "cb7f57b40f870409d7571844d0623f66d8078c90a9c255d9a4d4314b5ec3fc7c"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62336cdb621bcc2646e1be02bad6ee78b8004c12d633cafd44f340d5f77eebd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2250940d8c389902740a0a73e84e3018912083ecad3dfdea2967950ee079099a"
    sha256 cellar: :any_skip_relocation, monterey:       "1833ea0f497fed3106b3e22135c5cc83bc42b712ef7c1f3ea42faf0346924bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "22898510cec4fb04aa619bfe7174c3faf8769b6960b19b96d1cbe09f491bd52b"
    sha256 cellar: :any_skip_relocation, catalina:       "30b3ac2062681ac49593397b3fcccf485cdbec05cce26f6156471eefdd23f585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e866ab057b96ad911eb27854dd64437c40973f2a1ffa2f873d48ffe81636571"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
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
